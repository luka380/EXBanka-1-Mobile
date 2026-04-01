import SwiftUI

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

                Text("Generate a one-time verification code to authorize sensitive operations.")
                    .font(.subheadline)
                    .foregroundColor(.appMutedForeground)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppTheme.largePadding)

                if let code = viewModel.generatedCode {
                    VStack(spacing: AppTheme.smallPadding) {
                        Text("Your Code")
                            .font(.caption)
                            .foregroundColor(.appMutedForeground)
                        Text(code)
                            .font(.system(size: 42, weight: .bold, design: .monospaced))
                            .foregroundColor(.appPrimary)
                            .padding(AppTheme.padding)
                            .background(Color.appMuted)
                            .cornerRadius(AppTheme.cornerRadius)
                    }
                }

                Button(action: { viewModel.generateCode() }) {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .appPrimaryForeground))
                            .frame(maxWidth: .infinity, minHeight: 48)
                    } else {
                        Text(viewModel.generatedCode == nil ? "Generate Verification Code" : "Regenerate Code")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.appPrimaryForeground)
                            .frame(maxWidth: .infinity, minHeight: 48)
                    }
                }
                .background(Color.appPrimary)
                .cornerRadius(AppTheme.cornerRadius)
                .disabled(viewModel.isLoading)
                .padding(.horizontal, AppTheme.largePadding)

                Spacer()
            }
        }
        .navigationTitle("Verification")
        .navigationBarTitleDisplayMode(.inline)
    }
}
