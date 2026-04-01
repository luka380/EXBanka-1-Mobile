import SwiftUI

struct TransactionRowView: View {
    let payment: Payment

    private var formattedDate: String {
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let iso2 = ISO8601DateFormatter()
        if let date = iso.date(from: payment.timestamp) ?? iso2.date(from: payment.timestamp) {
            let f = DateFormatter()
            f.dateStyle = .medium
            f.timeStyle = .short
            return f.string(from: date)
        }
        return payment.timestamp
    }

    var body: some View {
        HStack(spacing: AppTheme.smallPadding) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(statusColor.opacity(0.12))
                    .frame(width: 40, height: 40)
                Image(systemName: "arrow.right.circle.fill")
                    .foregroundColor(statusColor)
                    .font(.system(size: 18))
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(payment.recipientName ?? payment.toAccountNumber)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.appForeground)
                    .lineLimit(1)
                Text(payment.paymentPurpose ?? "Payment")
                    .font(.caption)
                    .foregroundColor(.appMutedForeground)
                    .lineLimit(1)
                Text(formattedDate)
                    .font(.caption2)
                    .foregroundColor(.appMutedForeground)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 3) {
                Text(String(format: "%.2f", payment.finalAmount))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.appForeground)
                Text(payment.status.capitalized)
                    .font(.caption2)
                    .foregroundColor(statusColor)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(statusColor.opacity(0.1))
                    .cornerRadius(4)
            }
        }
        .padding(AppTheme.smallPadding + 4)
        .background(Color.appCard)
        .cornerRadius(AppTheme.cornerRadius)
    }

    private var statusColor: Color {
        switch payment.status.uppercased() {
        case "COMPLETED": return .green
        case "PENDING", "PENDING_VERIFICATION": return .orange
        case "FAILED", "REJECTED": return .appDestructive
        default: return .appMutedForeground
        }
    }
}
