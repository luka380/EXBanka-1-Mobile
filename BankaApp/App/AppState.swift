// Banka/App/AppState.swift
import SwiftUI
import Combine

@MainActor
final class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var currentUser: ClientProfile?
    @Published var accessToken: String?
    @Published var refreshToken: String?

    static let shared = AppState()
    private init() {}

    func login(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.isLoggedIn = true
    }

    func logout() {
        self.accessToken = nil
        self.refreshToken = nil
        self.currentUser = nil
        self.isLoggedIn = false
    }
}
