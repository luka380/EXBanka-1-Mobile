import Foundation

enum Endpoint {
    static let baseURL = "http://localhost:8080"

    // Existing
    case login
    case logout
    case me
    case myAccounts
    case paymentsForAccount(accountNumber: String)

    // Mobile Auth
    case mobileRequestActivation
    case mobileActivate
    case mobileRefresh

    // Mobile Device
    case mobileDevice
    case mobileDeviceDeactivate
    case mobileDeviceTransfer

    // Verification
    case pendingVerifications
    case submitVerification(challengeId: Int)
    case qrVerify(challengeId: Int)

    // WebSocket
    case mobileWebSocket

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

        case .mobileRequestActivation:
            return "\(Endpoint.baseURL)/api/mobile/auth/request-activation"
        case .mobileActivate:
            return "\(Endpoint.baseURL)/api/mobile/auth/activate"
        case .mobileRefresh:
            return "\(Endpoint.baseURL)/api/mobile/auth/refresh"

        case .mobileDevice:
            return "\(Endpoint.baseURL)/api/mobile/device"
        case .mobileDeviceDeactivate:
            return "\(Endpoint.baseURL)/api/mobile/device/deactivate"
        case .mobileDeviceTransfer:
            return "\(Endpoint.baseURL)/api/mobile/device/transfer"

        case .pendingVerifications:
            return "\(Endpoint.baseURL)/api/mobile/verifications/pending"
        case .submitVerification(let id):
            return "\(Endpoint.baseURL)/api/mobile/verifications/\(id)/submit"
        case .qrVerify(let id):
            return "\(Endpoint.baseURL)/api/verify/\(id)"

        case .mobileWebSocket:
            return "ws://localhost:8080/ws/mobile"
        }
    }

    var path: String {
        switch self {
        case .login: return "/api/auth/login"
        case .logout: return "/api/auth/logout"
        case .me: return "/api/me"
        case .myAccounts: return "/api/me/accounts"
        case .paymentsForAccount(let number):
            let encoded = number.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? number
            return "/api/payments/account/\(encoded)"
        case .mobileRequestActivation: return "/api/mobile/auth/request-activation"
        case .mobileActivate: return "/api/mobile/auth/activate"
        case .mobileRefresh: return "/api/mobile/auth/refresh"
        case .mobileDevice: return "/api/mobile/device"
        case .mobileDeviceDeactivate: return "/api/mobile/device/deactivate"
        case .mobileDeviceTransfer: return "/api/mobile/device/transfer"
        case .pendingVerifications: return "/api/mobile/verifications/pending"
        case .submitVerification(let id): return "/api/mobile/verifications/\(id)/submit"
        case .qrVerify(let id): return "/api/verify/\(id)"
        case .mobileWebSocket: return "/ws/mobile"
        }
    }

    var method: String {
        switch self {
        case .login, .logout,
             .mobileRequestActivation, .mobileActivate, .mobileRefresh,
             .mobileDeviceDeactivate, .mobileDeviceTransfer,
             .submitVerification, .qrVerify:
            return "POST"
        default:
            return "GET"
        }
    }
}
