import Foundation
import Combine

@MainActor
final class VerificationViewModel: ObservableObject {
    @Published var generatedCode: String?
    @Published var isLoading: Bool = false

    // Placeholder: generates a random 6-digit code locally.
    // Wire to a real backend endpoint when available.
    func generateCode() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.generatedCode = String(format: "%06d", Int.random(in: 0..<1_000_000))
            self.isLoading = false
        }
    }
}
