import SwiftUI

@main
struct BankaAppApp: App {
    @StateObject private var appState = AppState.shared
    @StateObject private var themeManager = ThemeManager.shared

    init() {
        if let accessToken = KeychainService.loadAccessToken(),
           let refreshToken = KeychainService.loadRefreshToken() {
            AppState.shared.login(accessToken: accessToken, refreshToken: refreshToken)
            Task {
                let profile = try? await APIClient.shared.request(
                    endpoint: .me,
                    accessToken: accessToken
                ) as ClientProfile
                await MainActor.run { AppState.shared.currentUser = profile }
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
        if appState.isLoggedIn {
            HomeView()
        } else {
            LoginView()
        }
    }
}
