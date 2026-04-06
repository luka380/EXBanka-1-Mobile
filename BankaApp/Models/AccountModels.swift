import Foundation

struct BankAccount: Decodable, Identifiable {
    let id: Int
    let accountNumber: String
    let accountName: String?
    let balance: String
    let availableBalance: String?
    let currencyCode: String
    let status: String
    let accountKind: String
    let accountType: String
    let accountCategory: String?
    let ownerName: String?
    let dailyLimit: String?
    let monthlyLimit: String?

    var formattedBalance: String {
        guard let value = Double(balance) else { return balance }
        return String(format: "%.2f", value)
    }
}

struct AccountsResponse: Decodable {
    let accounts: [BankAccount]
    let total: Int
}
