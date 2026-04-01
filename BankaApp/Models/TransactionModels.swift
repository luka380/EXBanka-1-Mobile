import Foundation

struct Payment: Decodable, Identifiable {
    let id: Int
    let fromAccountNumber: String
    let toAccountNumber: String
    let initialAmount: Double
    let finalAmount: Double
    let recipientName: String?
    let paymentPurpose: String?
    let status: String
    let timestamp: String
}

struct PaymentsResponse: Decodable {
    let payments: [Payment]
    let total: Int
}
