import Foundation
import Combine

@MainActor
final class ActivationRequestViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var codeSent: Bool = false

    func requestActivation() async {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            errorMessage = "Please enter your email address."
            return
        }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let _: ActivationRequestResponse = try await APIClient.shared.request(
                endpoint: .mobileRequestActivation,
                body: ActivationRequest(email: trimmed)
            )
            codeSent = true
        } catch let apiError as APIError {
            switch apiError {
            case .httpError(let statusCode, _):
                if statusCode == 404 {
                    errorMessage = "No account found for this email address."
                } else if statusCode == 400 {
                    errorMessage = "Please enter a valid email address."
                } else {
                    errorMessage = apiError.localizedDescription
                }
            default:
                errorMessage = apiError.localizedDescription
            }
        } catch {
            errorMessage = "Unable to connect. Please check your internet connection."
        }
    }
}
