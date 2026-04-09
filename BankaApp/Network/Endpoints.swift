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
        case .ackVerification(let id):
            return "\(Endpoint.baseURL)/api/v1/mobile/verifications/\(id)/ack"
        case .biometricVerification(let id):
            return "\(Endpoint.baseURL)/api/v1/mobile/verifications/\(id)/biometric"
        case .qrVerify(let id):
            return "\(Endpoint.baseURL)/api/verify/\(id)"

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
            return "\(Endpoint.baseURL)/api/me/accounts/\(id)"
        case .myCards:
            return "\(Endpoint.baseURL)/api/me/cards"
        case .myCardDetail(let id):
            return "\(Endpoint.baseURL)/api/me/cards/\(id)"
        case .myPayments:
            return "\(Endpoint.baseURL)/api/me/payments"
        case .myPaymentDetail(let id):
            return "\(Endpoint.baseURL)/api/me/payments/\(id)"
        case .myTransfers:
            return "\(Endpoint.baseURL)/api/me/transfers"
        case .myTransferDetail(let id):
            return "\(Endpoint.baseURL)/api/me/transfers/\(id)"
        case .myLoans:
            return "\(Endpoint.baseURL)/api/me/loans"
        case .myLoanDetail(let id):
            return "\(Endpoint.baseURL)/api/me/loans/\(id)"
        case .myLoanInstallments(let id):
            return "\(Endpoint.baseURL)/api/me/loans/\(id)/installments"
        case .myPortfolio:
            return "\(Endpoint.baseURL)/api/me/portfolio"
        case .myPortfolioSummary:
            return "\(Endpoint.baseURL)/api/me/portfolio/summary"
        case .myOrders:
            return "\(Endpoint.baseURL)/api/me/orders"
        case .myOrderDetail(let id):
            return "\(Endpoint.baseURL)/api/me/orders/\(id)"
        case .exchangeRates:
            return "\(Endpoint.baseURL)/api/exchange/rates"
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
        case .ackVerification(let id): return "/api/v1/mobile/verifications/\(id)/ack"
        case .biometricVerification(let id): return "/api/v1/mobile/verifications/\(id)/biometric"
        case .qrVerify(let id): return "/api/verify/\(id)"
        case .setBiometrics, .getBiometrics: return "/api/v1/mobile/device/biometrics"
        case .notifications: return "/api/v1/me/notifications"
        case .notificationUnreadCount: return "/api/v1/me/notifications/unread-count"
        case .markNotificationRead(let id): return "/api/v1/me/notifications/\(id)/read"
        case .markAllNotificationsRead: return "/api/v1/me/notifications/read-all"
        case .myAccountDetail(let id): return "/api/me/accounts/\(id)"
        case .myCards: return "/api/me/cards"
        case .myCardDetail(let id): return "/api/me/cards/\(id)"
        case .myPayments: return "/api/me/payments"
        case .myPaymentDetail(let id): return "/api/me/payments/\(id)"
        case .myTransfers: return "/api/me/transfers"
        case .myTransferDetail(let id): return "/api/me/transfers/\(id)"
        case .myLoans: return "/api/me/loans"
        case .myLoanDetail(let id): return "/api/me/loans/\(id)"
        case .myLoanInstallments(let id): return "/api/me/loans/\(id)/installments"
        case .myPortfolio: return "/api/me/portfolio"
        case .myPortfolioSummary: return "/api/me/portfolio/summary"
        case .myOrders: return "/api/me/orders"
        case .myOrderDetail(let id): return "/api/me/orders/\(id)"
        case .exchangeRates: return "/api/exchange/rates"
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
