import SwiftUI

struct DietaryRestrictionsView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: AppTheme.spacingLG) {
            Spacer()

            VStack(spacing: AppTheme.spacingSM) {
                Text("Dietary\npreferences?")
                    .font(AppTheme.largeTitle)
                    .foregroundStyle(AppTheme.deepCharcoal)
                    .multilineTextAlignment(.center)

                Text("Select any that apply")
                    .font(AppTheme.body)
                    .foregroundStyle(AppTheme.mutedText)
            }

            VStack(spacing: 0) {
                ForEach(AppConstants.DietaryRestriction.all, id: \.self) { restriction in
                    Button {
                        viewModel.toggleRestriction(restriction)
                    } label: {
                        HStack {
                            Text(restriction)
                                .font(AppTheme.body)
                                .foregroundStyle(AppTheme.deepCharcoal)

                            Spacer()

                            Image(systemName: viewModel.dietaryRestrictions.contains(restriction) ? "checkmark.circle.fill" : "circle")
                                .font(.title3)
                                .foregroundStyle(
                                    viewModel.dietaryRestrictions.contains(restriction) ? AppTheme.accent : AppTheme.mutedText.opacity(0.4)
                                )
                                .animation(.spring(response: 0.3), value: viewModel.dietaryRestrictions.contains(restriction))
                        }
                        .padding(.horizontal, AppTheme.spacingMD)
                        .padding(.vertical, 14)
                    }

                    if restriction != AppConstants.DietaryRestriction.all.last {
                        Divider()
                            .padding(.horizontal, AppTheme.spacingMD)
                    }
                }
            }
            .background(AppTheme.cardSurface)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerLG, style: .continuous))
            .padding(.horizontal, AppTheme.spacingSM)

            Spacer()
            Spacer()
        }
        .padding(.horizontal, AppTheme.spacingMD)
    }
}
