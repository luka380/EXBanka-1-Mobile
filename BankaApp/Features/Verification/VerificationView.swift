import SwiftUI

// TODO: Task 12 — replace this stub with full UI (code_pull, number_match, qr).
struct VerificationView: View {
    @StateObject private var viewModel = VerificationViewModel()

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            VStack(spacing: AppTheme.largePadding) {
                Spacer()

                Image(systemName: "checkmark.shield.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.appPrimary)

                Text("Verification")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.appForeground)

                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .appPrimary))
                }

                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AppTheme.largePadding)
                }

                if viewModel.pendingItems.isEmpty && !viewModel.isLoading {
                    Text("No pending verifications.")
                        .font(.subheadline)
                        .foregroundColor(.appMutedForeground)
                }

                Spacer()
            }
        }
        .navigationTitle("Verification")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { viewModel.startMonitoring() }
        .onDisappear { viewModel.stopMonitoring() }
    }
}
