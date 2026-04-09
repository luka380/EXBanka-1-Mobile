import SwiftUI

struct NotificationsView: View {
    @StateObject private var viewModel = NotificationsViewModel()

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            if viewModel.isLoading && viewModel.notifications.isEmpty {
                VStack(spacing: AppTheme.padding) {
                    ProgressView()
                    Text("Loading notifications...")
                        .font(.subheadline)
                        .foregroundColor(.appMutedForeground)
                }
            } else if viewModel.notifications.isEmpty {
                VStack(spacing: AppTheme.largePadding) {
                    Image(systemName: "bell.slash.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.appPrimary)
                    Text("No Notifications")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.appForeground)
                    Text("You're all caught up.")
                        .font(.subheadline)
                        .foregroundColor(.appMutedForeground)
                }
            } else {
                ScrollView {
                    VStack(spacing: AppTheme.smallPadding) {
                        ForEach(viewModel.notifications) { notification in
                            NotificationRow(notification: notification) {
                                Task { await viewModel.markAsRead(id: notification.id) }
                            }
                        }

                        if viewModel.notifications.count < viewModel.total {
                            Button("Load More") {
                                Task { await viewModel.loadMore() }
                            }
                            .font(.subheadline)
                            .foregroundColor(.appPrimary)
                            .padding()
                        }
                    }
                    .padding(AppTheme.padding)
                }
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if viewModel.unreadCount > 0 {
                    Button("Read All") {
                        Task { await viewModel.markAllAsRead() }
                    }
                    .font(.subheadline)
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchNotifications()
                await viewModel.fetchUnreadCount()
            }
        }
    }
}

struct NotificationRow: View {
    let notification: AppNotification
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: AppTheme.padding) {
                Image(systemName: iconName(for: notification.type))
                    .font(.system(size: 20))
                    .foregroundColor(.appPrimary)
                    .frame(width: 32)
                    .padding(.top, 2)

                VStack(alignment: .leading, spacing: 4) {
                    Text(notification.title)
                        .font(.system(size: 15, weight: notification.isRead ? .regular : .semibold))
                        .foregroundColor(.appForeground)

                    Text(notification.message)
                        .font(.system(size: 13))
                        .foregroundColor(.appMutedForeground)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    if let date = notification.creationDate {
                        Text(date, style: .relative)
                            .font(.caption2)
                            .foregroundColor(.appMutedForeground)
                    }
                }

                Spacer()

                if !notification.isRead {
                    Circle()
                        .fill(Color.appPrimary)
                        .frame(width: 8, height: 8)
                        .padding(.top, 6)
                }
            }
            .padding(AppTheme.padding)
            .background(notification.isRead ? Color.appCard : Color.appCard.opacity(0.9))
            .cornerRadius(AppTheme.cornerRadius)
            .shadow(color: Color.appForeground.opacity(0.04), radius: 4, x: 0, y: 1)
        }
    }

    private func iconName(for type: String) -> String {
        switch type {
        case "account_created": return "plus.rectangle.on.folder"
        case "card_issued": return "creditcard.fill"
        case "card_blocked": return "lock.rectangle.fill"
        case "money_sent": return "arrow.up.right.circle.fill"
        case "money_received": return "arrow.down.left.circle.fill"
        case "loan_approved": return "checkmark.circle.fill"
        case "loan_rejected": return "xmark.circle.fill"
        case "password_changed": return "key.fill"
        default: return "bell.fill"
        }
    }
}
