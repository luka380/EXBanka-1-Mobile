import Foundation

enum Endpoint {
//    static let baseURL = "http://localhost:8080"
    static let baseURL = "https://bytenity.com"

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
    case ackVerification(id: Int)
    case biometricVerification(challengeId: Int)
    case qrVerify(challengeId: Int)

    // Biometric Settings
    case setBiometrics
    case getBiometrics

    // Notifications
    case notifications
    case notificationUnreadCount
    case markNotificationRead(id: Int)
    case markAllNotificationsRead

    // Client read-only views
    case myAccountDetail(id: Int)
    case myCards
    case myCardDetail(id: Int)
    case myPayments
    case myPaymentDetail(id: Int)
    case myTransfers
    case myTransferDetail(id: Int)
    case myLoans
    case myLoanDetail(id: Int)
    case myLoanInstallments(loanId: Int)
    case myPortfolio
    case myPortfolioSummary
    case myOrders
    case myOrderDetail(id: Int)
    case exchangeRates

    var urlString: String {
        switch self {
        case .login:
            return "\(Endpoint.baseURL)/api/v1/auth/login"
        case .logout:
            return "\(Endpoint.baseURL)/api/v1/auth/logout"
        case .me:
            return "\(Endpoint.baseURL)/api/v1/me"
        case .myAccounts:
            return "\(Endpoint.baseURL)/api/v1/me/accounts"
        case .paymentsForAccount(let number):
            let encoded = number.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? number
            return "\(Endpoint.baseURL)/api/v1/payments/account/\(encoded)"

        case .mobileRequestActivation:
            return "\(Endpoint.baseURL)/api/v1/mobile/auth/request-activation"
        case .mobileActivate:
            return "\(Endpoint.baseURL)/api/v1/mobile/auth/activate"
        case .mobileRefresh:
            return "\(Endpoint.baseURL)/api/v1/mobile/auth/refresh"

        case .mobileDevice:
            return "\(Endpoint.baseURL)/api/v1/mobile/device"
        case .mobileDeviceDeactivate:
            return "\(Endpoint.baseURL)/api/v1/mobile/device/deactivate"
        case .mobileDeviceTransfer:
            return "\(Endpoint.baseURL)/api/v1/mobile/device/transfer"

        case .pendingVerifications:
            return "\(Endpoint.baseURL)/api/v1/mobile/verifications/pending"
        case .submitVerification(let id):
            return "\(Endpoint.baseURL)/api/v1/mobile/verifications/\(id)/submit"
        case .ackVerification(let id):
            return "\(Endpoint.baseURL)/api/v1/mobile/verifications/\(id)/ack"
        case .biometricVerification(let id):
            return "\(Endpoint.baseURL)/api/v1/mobile/verifications/\(id)/biometric"
        case .qrVerify(let id):
            return "\(Endpoint.baseURL)/api/v1/verify/\(id)"

        case .setBiometrics, .getBiometrics:
            return "\(Endpoint.baseURL)/api/v1/mobile/device/biometrics"

        case .notifications:
            return "\(Endpoint.baseURL)/api/v1/me/notifications"
        case .notificationUnreadCount:
            return "\(Endpoint.baseURL)/api/v1/me/notifications/unread-count"
        case .markNotificationRead(let id):
            return "\(Endpoint.baseURL)/api/v1/me/notifications/\(id)/read"
        case .markAllNotificationsRead:
            return "\(Endpoint.baseURL)/api/v1/me/notifications/read-all"

        case .myAccountDetail(let id):
            return "\(Endpoint.baseURL)/api/v1/me/accounts/\(id)"
        case .myCards:
            return "\(Endpoint.baseURL)/api/v1/me/cards"
        case .myCardDetail(let id):
            return "\(Endpoint.baseURL)/api/v1/me/cards/\(id)"
        case .myPayments:
            return "\(Endpoint.baseURL)/api/v1/me/payments"
        case .myPaymentDetail(let id):
            return "\(Endpoint.baseURL)/api/v1/me/payments/\(id)"
        case .myTransfers:
            return "\(Endpoint.baseURL)/api/v1/me/transfers"
        case .myTransferDetail(let id):
            return "\(Endpoint.baseURL)/api/v1/me/transfers/\(id)"
        case .myLoans:
            return "\(Endpoint.baseURL)/api/v1/me/loans"
        case .myLoanDetail(let id):
            return "\(Endpoint.baseURL)/api/v1/me/loans/\(id)"
        case .myLoanInstallments(let id):
            return "\(Endpoint.baseURL)/api/v1/me/loans/\(id)/installments"
        case .myPortfolio:
            return "\(Endpoint.baseURL)/api/v1/me/portfolio"
        case .myPortfolioSummary:
            return "\(Endpoint.baseURL)/api/v1/me/portfolio/summary"
        case .myOrders:
            return "\(Endpoint.baseURL)/api/v1/me/orders"
        case .myOrderDetail(let id):
            return "\(Endpoint.baseURL)/api/v1/me/orders/\(id)"
        case .exchangeRates:
            return "\(Endpoint.baseURL)/api/v1/exchange/rates"
        }
    }

    var path: String {
        switch self {
        case .login: return "/api/v1/auth/login"
        case .logout: return "/api/v1/auth/logout"
        case .me: return "/api/v1/me"
        case .myAccounts: return "/api/v1/me/accounts"
        case .paymentsForAccount(let number):
            let encoded = number.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? number
            return "/api/v1/payments/account/\(encoded)"
        case .mobileRequestActivation: return "/api/v1/mobile/auth/request-activation"
        case .mobileActivate: return "/api/v1/mobile/auth/activate"
        case .mobileRefresh: return "/api/v1/mobile/auth/refresh"
        case .mobileDevice: return "/api/v1/mobile/device"
        case .mobileDeviceDeactivate: return "/api/v1/mobile/device/deactivate"
        case .mobileDeviceTransfer: return "/api/v1/mobile/device/transfer"
        case .pendingVerifications: return "/api/v1/mobile/verifications/pending"
        case .submitVerification(let id): return "/api/v1/mobile/verifications/\(id)/submit"
        case .ackVerification(let id): return "/api/v1/mobile/verifications/\(id)/ack"
        case .biometricVerification(let id): return "/api/v1/mobile/verifications/\(id)/biometric"
        case .qrVerify(let id): return "/api/v1/verify/\(id)"
        case .setBiometrics, .getBiometrics: return "/api/v1/mobile/device/biometrics"
        case .notifications: return "/api/v1/me/notifications"
        case .notificationUnreadCount: return "/api/v1/me/notifications/unread-count"
        case .markNotificationRead(let id): return "/api/v1/me/notifications/\(id)/read"
        case .markAllNotificationsRead: return "/api/v1/me/notifications/read-all"
        case .myAccountDetail(let id): return "/api/v1/me/accounts/\(id)"
        case .myCards: return "/api/v1/me/cards"
        case .myCardDetail(let id): return "/api/v1/me/cards/\(id)"
        case .myPayments: return "/api/v1/me/payments"
        case .myPaymentDetail(let id): return "/api/v1/me/payments/\(id)"
        case .myTransfers: return "/api/v1/me/transfers"
        case .myTransferDetail(let id): return "/api/v1/me/transfers/\(id)"
        case .myLoans: return "/api/v1/me/loans"
        case .myLoanDetail(let id): return "/api/v1/me/loans/\(id)"
        case .myLoanInstallments(let id): return "/api/v1/me/loans/\(id)/installments"
        case .myPortfolio: return "/api/v1/me/portfolio"
        case .myPortfolioSummary: return "/api/v1/me/portfolio/summary"
        case .myOrders: return "/api/v1/me/orders"
        case .myOrderDetail(let id): return "/api/v1/me/orders/\(id)"
        case .exchangeRates: return "/api/v1/exchange/rates"
        }
    }

    var method: String {
        switch self {
        case .login, .logout,
             .mobileRequestActivation, .mobileActivate, .mobileRefresh,
             .mobileDeviceDeactivate, .mobileDeviceTransfer,
             .submitVerification, .ackVerification, .biometricVerification, .qrVerify,
             .setBiometrics,
             .markNotificationRead, .markAllNotificationsRead:
            return "POST"
        default:
            return "GET"
        }
    }
}
