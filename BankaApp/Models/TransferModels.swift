import Foundation

struct Transfer: Decodable, Identifiable {
    let id: Int
    let fromAccountNumber: String
    let toAccountNumber: String
    let initialAmount: String
    let finalAmount: String
    let exchangeRate: String?
    let commission: String?
    let timestamp: String
}

struct TransfersResponse: Decodable {
    let transfers: [Transfer]
    let total: Int
}
