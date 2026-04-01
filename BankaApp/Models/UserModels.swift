import Foundation

struct ClientProfile: Decodable, Identifiable {
    let id: Int
    let firstName: String
    let lastName: String
    let email: String
    let phone: String?
    let address: String?
    let active: Bool?

    var fullName: String { "\(firstName) \(lastName)" }
}
