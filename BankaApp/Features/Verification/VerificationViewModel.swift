import Foundation
import Combine

@MainActor
final class VerificationViewModel: ObservableObject {
    @Published var pendingItems: [PendingVerificationItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var submitSuccess: Bool = false

    private let appState: AppState
    private var pollTimer: Timer?

    init(appState: AppState = .shared) {
        self.appState = appState
    }

    func startMonitoring() {
        startPolling()
        Task { await fetchPending() }
    }

    func stopMonitoring() {
        pollTimer?.invalidate()
        pollTimer = nil
    }

    func fetchPending() async {
        guard let token = appState.accessToken,
              let deviceId = appState.deviceId,
              let secret = KeychainService.loadDeviceSecret() else { return }

        isLoading = pendingItems.isEmpty
        defer { isLoading = false }

        do {
            let response: PendingVerificationsResponse = try await APIClient.shared.signedRequest(
                endpoint: .pendingVerifications,
                accessToken: token,
                deviceId: deviceId,
                deviceSecret: secret
            )
            pendingItems = response.items.filter { !$0.isExpired }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func submitCodePull(challengeId: Int, code: String) async {
        await submitVerification(
            challengeId: challengeId,
            body: VerificationSubmitRequest(response: code)
        )
    }

    func submitNumberMatch(challengeId: Int, selectedNumber: Int) async {
        await submitVerification(
            challengeId: challengeId,
            body: VerificationSubmitRequest(response: String(selectedNumber))
        )
    }

    func ackVerification(id: Int) async {
        guard let token = appState.accessToken,
              let deviceId = appState.deviceId,
              let secret = KeychainService.loadDeviceSecret() else { return }

        do {
            let _: VerificationAckResponse = try await APIClient.shared.signedRequest(
                endpoint: .ackVerification(id: id),
                accessToken: token,
                deviceId: deviceId,
                deviceSecret: secret
            )
            removeChallenge(id)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func submitBiometric(challengeId: Int) async {
        guard let token = appState.accessToken,
              let deviceId = appState.deviceId,
              let secret = KeychainService.loadDeviceSecret() else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let response: BiometricVerificationResponse = try await APIClient.shared.signedRequest(
                endpoint: .biometricVerification(challengeId: challengeId),
                accessToken: token,
                deviceId: deviceId,
                deviceSecret: secret
            )
            if response.success {
                removeChallenge(challengeId)
                submitSuccess = true
            } else {
                errorMessage = "Biometric verification failed."
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func submitQrToken(challengeId: Int, token: String) async {
        guard let accessToken = appState.accessToken,
              let deviceId = appState.deviceId,
              let secret = KeychainService.loadDeviceSecret() else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            // QR verification uses a different endpoint with token as query param
            guard var components = URLComponents(
                string: Endpoint.qrVerify(challengeId: challengeId).urlString
            ) else { return }
            components.queryItems = [URLQueryItem(name: "token", value: token)]

            guard let url = components.url else { return }

            let endpoint = Endpoint.qrVerify(challengeId: challengeId)
            let bodyData: Data? = nil
            let headers = RequestSigner.sign(
                method: "POST",
                path: endpoint.path,
                body: bodyData,
                deviceId: deviceId,
                deviceSecret: secret
            )

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            request.setValue(headers.deviceId, forHTTPHeaderField: "X-Device-ID")
            request.setValue(headers.timestamp, forHTTPHeaderField: "X-Device-Timestamp")
            request.setValue(headers.signature, forHTTPHeaderField: "X-Device-Signature")

            let (data, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse,
                  (200..<300).contains(http.statusCode) else {
                throw APIError.httpError(statusCode: 0, message: "QR verification failed")
            }
            _ = data
            removeChallenge(challengeId)
            submitSuccess = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Private

    private func submitVerification(challengeId: Int, body: VerificationSubmitRequest) async {
        guard let token = appState.accessToken,
              let deviceId = appState.deviceId,
              let secret = KeychainService.loadDeviceSecret() else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let response: VerificationSubmitResponse = try await APIClient.shared.signedRequest(
                endpoint: .submitVerification(challengeId: challengeId),
                body: body,
                accessToken: token,
                deviceId: deviceId,
                deviceSecret: secret
            )
            if response.success == true || response.status == "verified" {
                removeChallenge(challengeId)
                submitSuccess = true
            } else {
                errorMessage = "Verification failed. Attempts remaining: \(response.remainingAttempts ?? 0)"
            }
        } catch let apiError as APIError {
            errorMessage = apiError.localizedDescription
            // On 409 with new options for number_match, re-fetch pending to get updated display_data
            if case .httpError(let code, _) = apiError, code == 409 {
                await fetchPending()
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func startPolling() {
        pollTimer?.invalidate()
        pollTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [weak self] _ in
            Task { @MainActor in
                await self?.fetchPending()
            }
        }
    }

    private func addOrUpdateChallenge(_ item: PendingVerificationItem) {
        if let idx = pendingItems.firstIndex(where: { $0.challengeId == item.challengeId }) {
            pendingItems[idx] = item
        } else {
            pendingItems.insert(item, at: 0)
        }
    }

    private func removeChallenge(_ challengeId: Int) {
        pendingItems.removeAll { $0.challengeId == challengeId }
    }
}
