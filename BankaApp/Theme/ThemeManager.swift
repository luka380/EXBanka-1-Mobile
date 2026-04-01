import SwiftUI
import Combine

@MainActor
final class ThemeManager: ObservableObject {
    @Published var isDarkMode: Bool

    static let shared = ThemeManager()
    private init() {
        isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
    }

    func toggle() {
        isDarkMode.toggle()
        UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
    }
}
