import SwiftUI

struct AccountDetailView: View {
    let account: BankAccount
    @StateObject private var viewModel: AccountDetailViewModel

    init(account: BankAccount) {
        self.account = account
        _viewModel = StateObject(wrappedValue: AccountDetailViewModel(
            appState: AppState.shared,
            accountNumber: account.accountNumber
        ))
    }

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            ScrollView {
                VStack(spacing: AppTheme.padding) {
                    AccountHeaderCard(account: account)

                    VStack(alignment: .leading, spacing: AppTheme.smallPadding) {
                        Text("Transactions")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.appForeground)

                        if viewModel.isLoading {
                            ProgressView().frame(maxWidth: .infinity).padding()
                        } else if let error = viewModel.errorMessage {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.appDestructive)
                        } else if viewModel.payments.isEmpty {
                            Text("No transactions yet.")
                                .font(.subheadline)
                                .foregroundColor(.appMutedForeground)
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            ForEach(viewModel.payments) { payment in
                                TransactionRowView(payment: payment)
                            }
                        }
                    }
                }
                .padding(AppTheme.padding)
            }
        }
        .navigationTitle(account.accountName ?? "Account")
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.loadTransactions() }
    }
}

struct AccountHeaderCard: View {
    let account: BankAccount

    var body: some View {
        VStack(spacing: AppTheme.smallPadding) {
            Text(account.accountNumber)
                .font(.system(size: 13, design: .monospaced))
                .foregroundColor(.appMutedForeground)

            Text("\(account.balance) \(account.currencyCode)")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.appForeground)

            HStack(spacing: 4) {
                Circle()
                    .fill(account.status.lowercased() == "active" ? Color.green : Color.appDestructive)
                    .frame(width: 7, height: 7)
                Text(account.status.capitalized)
                    .font(.caption)
                    .foregroundColor(.appMutedForeground)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(AppTheme.largePadding)
        .background(
            LinearGradient(
                colors: [Color.appPrimary.opacity(0.85), Color.appAccent.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(AppTheme.cornerRadius * 1.4)
    }
}
