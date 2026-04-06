import SwiftUI

struct AccountRowView: View {
    let account: BankAccount

    var body: some View {
        HStack(spacing: AppTheme.padding) {
            ZStack {
                Circle()
                    .fill(Color.appPrimary.opacity(0.12))
                    .frame(width: 44, height: 44)
                Image(systemName: "creditcard.fill")
                    .foregroundColor(.appPrimary)
                    .font(.system(size: 18))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(account.accountName ?? account.accountNumber)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.appForeground)
                    .lineLimit(1)
                Text(account.accountNumber)
                    .font(.caption)
                    .foregroundColor(.appMutedForeground)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("\(account.formattedBalance) \(account.currencyCode)")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.appForeground)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Text(account.status.capitalized)
                    .font(.caption2)
                    .foregroundColor(account.status.lowercased() == "active" ? .green : .appDestructive)
            }
        }
        .padding(AppTheme.padding)
        .background(Color.appCard)
        .cornerRadius(AppTheme.cornerRadius)
        .shadow(color: Color.appForeground.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
