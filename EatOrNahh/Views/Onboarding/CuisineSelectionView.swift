import SwiftUI

struct CuisineSelectionView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: AppTheme.spacingLG) {
            Spacer()

            VStack(spacing: AppTheme.spacingSM) {
                Text("What cuisines\ndo you love?")
                    .font(AppTheme.largeTitle)
                    .foregroundStyle(AppTheme.deepCharcoal)
                    .multilineTextAlignment(.center)

                Text("Pick as many as you like")
                    .font(AppTheme.body)
                    .foregroundStyle(AppTheme.mutedText)
            }

            FlowLayout(spacing: 10) {
                ForEach(AppConstants.Cuisine.all, id: \.self) { cuisine in
                    PillChipView(
                        label: cuisine,
                        isSelected: viewModel.selectedCuisines.contains(cuisine),
                        action: { viewModel.toggleCuisine(cuisine) }
                    )
                }
            }
            .padding(.horizontal, AppTheme.spacingSM)

            Spacer()
            Spacer()
        }
        .padding(.horizontal, AppTheme.spacingMD)
    }
}
