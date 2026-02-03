import SwiftUI

struct PreferencesEditorView: View {
    @Bindable var viewModel: ProfileViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.spacingLG) {
            // Spice tolerance
            VStack(alignment: .leading, spacing: AppTheme.spacingSM) {
                Text("Spice Tolerance")
                    .font(AppTheme.headline)
                    .foregroundStyle(AppTheme.deepCharcoal)

                HStack {
                    Text("Mild")
                        .font(AppTheme.caption)
                        .foregroundStyle(AppTheme.mutedText)
                    Slider(value: $viewModel.spiceTolerance, in: 0...5, step: 1)
                        .tint(AppTheme.accent)
                    Text("Extreme")
                        .font(AppTheme.caption)
                        .foregroundStyle(AppTheme.mutedText)
                }
            }

            // Cuisines
            VStack(alignment: .leading, spacing: AppTheme.spacingSM) {
                Text("Favorite Cuisines")
                    .font(AppTheme.headline)
                    .foregroundStyle(AppTheme.deepCharcoal)

                FlowLayout(spacing: 8) {
                    ForEach(AppConstants.Cuisine.all, id: \.self) { cuisine in
                        PillChipView(
                            label: cuisine,
                            isSelected: viewModel.selectedCuisines.contains(cuisine),
                            action: { viewModel.toggleCuisine(cuisine) }
                        )
                    }
                }
            }

            // Allergies
            VStack(alignment: .leading, spacing: AppTheme.spacingSM) {
                Text("Allergies")
                    .font(AppTheme.headline)
                    .foregroundStyle(AppTheme.deepCharcoal)

                FlowLayout(spacing: 8) {
                    ForEach(AppConstants.Allergen.all, id: \.self) { allergen in
                        PillChipView(
                            label: allergen,
                            isSelected: viewModel.allergies.contains(allergen),
                            action: { viewModel.toggleAllergy(allergen) }
                        )
                    }
                }
            }

            // Dietary restrictions
            VStack(alignment: .leading, spacing: AppTheme.spacingSM) {
                Text("Dietary Preferences")
                    .font(AppTheme.headline)
                    .foregroundStyle(AppTheme.deepCharcoal)

                FlowLayout(spacing: 8) {
                    ForEach(AppConstants.DietaryRestriction.all, id: \.self) { restriction in
                        PillChipView(
                            label: restriction,
                            isSelected: viewModel.dietaryRestrictions.contains(restriction),
                            action: { viewModel.toggleRestriction(restriction) }
                        )
                    }
                }
            }
        }
    }
}
