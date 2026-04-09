import Foundation
import Combine

@MainActor
final class NotificationsViewModel: ObservableObject {
    @Published var notifications: [AppNotification] = []
    @Published var unreadCount: Int = 0
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var total: Int = 0

    private let appState: AppState
    private var currentPage: Int = 1
    private let pageSize: Int = 20

    init(appState: AppState = .shared) {
        self.appState = appState
    }

    func fetchNotifications(page: Int = 1) async {
        guard let token = appState.accessToken else { return }

        isLoading = notifications.isEmpty
        defer { isLoading = false }

        do {
            let response: NotificationsResponse = try await APIClient.shared.request(
                endpoint: .notifications,
                accessToken: token,
                deviceId: appState.deviceId
            )
            if page == 1 {
                notifications = response.notifications
            } else {
                notifications.append(contentsOf: response.notifications)
            }
            total = response.total
            currentPage = page
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func fetchUnreadCount() async {
        guard let token = appState.accessToken else { return }

        do {
            let response: UnreadCountResponse = try await APIClient.shared.request(
                endpoint: .notificationUnreadCount,
                accessToken: token,
                deviceId: appState.deviceId
            )
            unreadCount = response.unreadCount
        } catch {
            // Silently fail for badge count
        }
    }

    func markAsRead(id: Int) async {
        guard let token = appState.accessToken else { return }

        do {
            let _: MarkReadResponse = try await APIClient.shared.request(
                endpoint: .markNotificationRead(id: id),
                accessToken: token,
                deviceId: appState.deviceId
            )
            if let idx = notifications.firstIndex(where: { $0.id == id }) {
                let n = notifications[idx]
                if !n.isRead {
                    unreadCount = max(0, unreadCount - 1)
                }
                // Re-fetch to get updated state
                await fetchNotifications(page: 1)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func markAllAsRead() async {
        guard let token = appState.accessToken else { return }

        do {
            let _: MarkAllReadResponse = try await APIClient.shared.request(
                endpoint: .markAllNotificationsRead,
                accessToken: token,
                deviceId: appState.deviceId
            )
            unreadCount = 0
            await fetchNotifications(page: 1)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func loadMore() async {
        guard notifications.count < total else { return }
        await fetchNotifications(page: currentPage + 1)
    }
}
