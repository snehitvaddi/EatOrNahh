import SwiftUI

struct AllergySelectionView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: AppTheme.spacingLG) {
            Spacer()

            VStack(spacing: AppTheme.spacingSM) {
                Text("Any allergies?")
                    .font(AppTheme.largeTitle)
                    .foregroundStyle(AppTheme.deepCharcoal)
                    .multilineTextAlignment(.center)

                Text("We'll make sure to avoid these")
                    .font(AppTheme.body)
                    .foregroundStyle(AppTheme.mutedText)
            }

            FlowLayout(spacing: 10) {
                ForEach(AppConstants.Allergen.all, id: \.self) { allergen in
                    PillChipView(
                        label: allergen,
                        isSelected: viewModel.allergies.contains(allergen),
                        action: { viewModel.toggleAllergy(allergen) }
                    )
                }
            }
            .padding(.horizontal, AppTheme.spacingSM)

            Text("You can skip this if you have none")
                .font(AppTheme.caption)
                .foregroundStyle(AppTheme.mutedText)

            Spacer()
            Spacer()
        }
        .padding(.horizontal, AppTheme.spacingMD)
    }
}
