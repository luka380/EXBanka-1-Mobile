import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject private var viewModel: HomeViewModel
    @State private var isMenuOpen: Bool = false

    init() {
        _viewModel = StateObject(wrappedValue: HomeViewModel(appState: AppState.shared))
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .trailing) {
                Color.appBackground.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: AppTheme.padding) {
                        WelcomeCard(
                            profile: viewModel.profile,
                            isLoading: viewModel.isLoading,
                            errorMessage: viewModel.errorMessage,
                        )

                        AccountsListView()
                    }
                    .padding(AppTheme.padding)
                }
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { withAnimation(.easeInOut) { isMenuOpen.toggle() } }) {
                            Image(systemName: "line.3.horizontal")
                                .foregroundColor(.appForeground)
                        }
                    }
                }

                if isMenuOpen {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture { withAnimation(.easeInOut) { isMenuOpen = false } }

                    SideMenuView(isOpen: $isMenuOpen)
                        .transition(.move(edge: .trailing))
                }
            }
        }
        .task { await viewModel.loadProfile() }
    }
}

struct WelcomeCard: View {
    let profile: ClientProfile?
    let isLoading: Bool
    let errorMessage: String?

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.smallPadding) {
            if isLoading {
                HStack {
                    ProgressView()
                    Text("Loading profile…")
                        .font(.subheadline)
                        .foregroundColor(.appMutedForeground)
                }
            } else if let profile {
                Text("Welcome, \(profile.firstName)!")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.appForeground)

                Divider().background(Color.appBorder).padding(.vertical, 4)

                LabeledRow(label: "First Name", value: profile.firstName)
                LabeledRow(label: "Last Name", value: profile.lastName)
                LabeledRow(label: "Email", value: profile.email)
            } else {
                Text("Welcome!")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.appForeground)

                if let error = errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.appDestructive)
                        .padding(.top, 2)
                }

            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppTheme.padding)
        .background(Color.appCard)
        .cornerRadius(AppTheme.cornerRadius * 1.4)
        .shadow(color: Color.appForeground.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

struct LabeledRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundColor(.appMutedForeground)
            Spacer()
            Text(value)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.appForeground)
        }
    }
}
