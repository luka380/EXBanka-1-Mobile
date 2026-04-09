import Foundation

struct Loan: Decodable, Identifiable {
    let id: Int
    let loanNumber: String?
    let loanType: String
    let accountNumber: String?
    let amount: Double
    let repaymentPeriod: Int?
    let nominalInterestRate: Double?
    let effectiveInterestRate: Double?
    let interestType: String?
    let contractDate: String?
    let maturityDate: String?
    let nextInstallmentAmount: Double?
    let nextInstallmentDate: String?
    let remainingDebt: Double?
    let currencyCode: String?
    let status: String
    let createdAt: String?

    var displayInterestRate: Double {
        nominalInterestRate ?? effectiveInterestRate ?? 0
    }

    var loanTypeLabel: String {
        switch loanType.uppercased() {
        case "CASH": return "Cash Loan"
        case "PERSONAL": return "Personal Loan"
        case "HOUSING", "MORTGAGE": return "Housing Loan"
        case "AUTO": return "Auto Loan"
        case "REFINANCING": return "Refinancing"
        case "STUDENT": return "Student Loan"
        case "BUSINESS": return "Business Loan"
        default: return loanType
        }
    }
}

struct LoansResponse: Decodable {
    let loans: [Loan]
    let total: Int
}

struct LoanInstallment: Decodable, Identifiable {
    var id: Int { installmentNumber }
    let installmentNumber: Int
    let dueDate: String
    let amount: Double
    let status: String
}

struct InstallmentsResponse: Decodable {
    let installments: [LoanInstallment]
}
