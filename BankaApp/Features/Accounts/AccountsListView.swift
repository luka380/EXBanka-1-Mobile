import SwiftUI

struct AccountsListView: View {
    @StateObject private var viewModel = AccountsViewModel(appState: AppState.shared)

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.smallPadding) {
            Text("My Accounts")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.appForeground)

            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding()
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.appDestructive)
            } else if viewModel.accounts.isEmpty {
                Text("No accounts found.")
                    .font(.subheadline)
                    .foregroundColor(.appMutedForeground)
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                ForEach(viewModel.accounts) { account in
                    NavigationLink(destination: AccountDetailView(account: account)) {
                        AccountRowView(account: account)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .task { await viewModel.loadAccounts() }
    }
}
