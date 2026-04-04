import SwiftUI

@main
struct BankaAppApp: App {
    @StateObject private var appState = AppState.shared
    @StateObject private var themeManager = ThemeManager.shared

    init() {
        if let accessToken = KeychainService.loadAccessToken(),
           let refreshToken = KeychainService.loadRefreshToken(),
           let deviceId = KeychainService.loadDeviceId() {
            AppState.shared.restoreSession(
                accessToken: accessToken,
                refreshToken: refreshToken,
                deviceId: deviceId
            )
            Task {
                do {
                    let profile: ClientProfile = try await APIClient.shared.request(
                        endpoint: .me,
                        accessToken: accessToken,
                        deviceId: deviceId
                    )
                    await MainActor.run { AppState.shared.currentUser = profile }
                } catch APIError.unauthorized {
                    do {
                        let refreshed = try await APIClient.shared.refreshTokens(
                            refreshToken: refreshToken,
                            deviceId: deviceId
                        )
                        await MainActor.run {
                            AppState.shared.updateTokens(
                                accessToken: refreshed.accessToken,
                                refreshToken: refreshed.refreshToken
                            )
                        }
                        let profile: ClientProfile = try await APIClient.shared.request(
                            endpoint: .me,
                            accessToken: refreshed.accessToken,
                            deviceId: deviceId
                        )
                        await MainActor.run { AppState.shared.currentUser = profile }
                    } catch {
                        await MainActor.run { AppState.shared.logout() }
                    }
                } catch APIError.deviceDeactivated {
                    await MainActor.run { AppState.shared.logout() }
                } catch {
                    // Network error on startup — keep session, user can retry
                }
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
        }
    }
}

struct RootView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        if appState.isActivated {
            HomeView()
        } else {
            ActivationRequestView()
        }
    }
}
