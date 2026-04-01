import Foundation

enum Endpoint {
    static let baseURL = "http://localhost:8080"

    case login
    case logout
    case me
    case myAccounts
    case paymentsForAccount(accountNumber: String)

    var urlString: String {
        switch self {
        case .login:
            return "\(Endpoint.baseURL)/api/auth/login"
        case .logout:
            return "\(Endpoint.baseURL)/api/auth/logout"
        case .me:
            return "\(Endpoint.baseURL)/api/me"
        case .myAccounts:
            return "\(Endpoint.baseURL)/api/me/accounts"
        case .paymentsForAccount(let number):
            let encoded = number.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? number
            return "\(Endpoint.baseURL)/api/payments/account/\(encoded)"
        }
    }

    var method: String {
        switch self {
        case .login, .logout:
            return "POST"
        default:
            return "GET"
        }
    }
}
