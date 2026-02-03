import SwiftUI

struct OnboardingContainerView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) private var appState
    @State private var viewModel = OnboardingViewModel()

    var body: some View {
        ZStack {
            AppTheme.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Page content
                TabView(selection: $viewModel.currentPage) {
                    SpiceToleranceView(viewModel: viewModel)
                        .tag(0)

                    CuisineSelectionView(viewModel: viewModel)
                        .tag(1)

                    AllergySelectionView(viewModel: viewModel)
                        .tag(2)

                    DietaryRestrictionsView(viewModel: viewModel)
                        .tag(3)

                    OnboardingCompleteView(viewModel: viewModel)
                        .tag(4)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: viewModel.currentPage)

                // Bottom controls
                VStack(spacing: AppTheme.spacingMD) {
                    // Page indicators
                    HStack(spacing: 8) {
                        ForEach(0..<viewModel.totalPages, id: \.self) { index in
                            Capsule()
                                .fill(index == viewModel.currentPage ? AppTheme.accent : AppTheme.mutedText.opacity(0.2))
                                .frame(width: index == viewModel.currentPage ? 24 : 8, height: 8)
                                .animation(.spring(response: 0.3), value: viewModel.currentPage)
                        }
                    }

                    // Buttons
                    HStack(spacing: AppTheme.spacingMD) {
                        if viewModel.currentPage > 0 {
                            Button {
                                viewModel.previousPage()
                            } label: {
                                Text("Back")
                                    .font(AppTheme.headline)
                                    .foregroundStyle(AppTheme.mutedText)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(AppTheme.cardSurface)
                                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerPill, style: .continuous))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: AppTheme.cornerPill, style: .continuous)
                                            .stroke(AppTheme.borderColor, lineWidth: AppTheme.borderWidth)
                                    )
                            }
                            .transition(.move(edge: .leading).combined(with: .opacity))
                        }

                        Button {
                            if viewModel.isLastPage {
                                viewModel.saveProfile(context: modelContext, appState: appState)
                            } else {
                                viewModel.nextPage()
                            }
                        } label: {
                            Text(viewModel.isLastPage ? "Let's Eat" : "Next")
                                .font(AppTheme.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(AppTheme.accent)
                                .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerPill, style: .continuous))
                        }
                    }
                    .animation(.spring(response: 0.3), value: viewModel.currentPage)
                }
                .padding(.horizontal, AppTheme.spacingMD)
                .padding(.bottom, AppTheme.spacingLG)
            }
        }
    }
}
