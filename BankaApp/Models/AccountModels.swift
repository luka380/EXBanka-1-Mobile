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
}

struct AccountsResponse: Decodable {
    let accounts: [BankAccount]
    let total: Int
}
