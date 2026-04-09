import Foundation

struct AppNotification: Decodable, Identifiable {
    let id: Int
    let type: String
    let title: String
    let message: String
    let isRead: Bool
    let refType: String?
    let refId: Int?
    let createdAt: String

    var creationDate: Date? {
        ISO8601DateFormatter().date(from: createdAt)
    }
}

struct NotificationsResponse: Decodable {
    let notifications: [AppNotification]
    let total: Int
}

struct UnreadCountResponse: Decodable {
    let unreadCount: Int
}

struct MarkReadResponse: Decodable {
    let success: Bool
}

struct MarkAllReadResponse: Decodable {
    let success: Bool
    let count: Int
}
