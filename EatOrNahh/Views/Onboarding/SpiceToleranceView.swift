import SwiftUI

struct SpiceToleranceView: View {
    @Bindable var viewModel: OnboardingViewModel

    private let spiceLevels = [
        (emoji: "🫑", label: "No spice"),
        (emoji: "🌶️", label: "Mild"),
        (emoji: "🌶️🌶️", label: "Medium"),
        (emoji: "🔥", label: "Spicy"),
        (emoji: "🔥🔥", label: "Very spicy"),
        (emoji: "💀", label: "Bring it on"),
    ]

    var body: some View {
        VStack(spacing: AppTheme.spacingXL) {
            Spacer()

            Text("How spicy do\nyou like it?")
                .font(AppTheme.largeTitle)
                .foregroundStyle(AppTheme.deepCharcoal)
                .multilineTextAlignment(.center)

            VStack(spacing: AppTheme.spacingMD) {
                Text(spiceLevels[Int(viewModel.spiceTolerance)].emoji)
                    .font(.system(size: 64))
                    .contentTransition(.numericText())

                Text(spiceLevels[Int(viewModel.spiceTolerance)].label)
                    .font(AppTheme.title)
                    .foregroundStyle(AppTheme.deepCharcoal)
                    .contentTransition(.numericText())
            }
            .animation(.spring(response: 0.3), value: viewModel.spiceTolerance)

            VStack(spacing: AppTheme.spacingSM) {
                Slider(
                    value: $viewModel.spiceTolerance,
                    in: 0...5,
                    step: 1
                )
                .tint(AppTheme.accent)
                .padding(.horizontal, AppTheme.spacingLG)

                HStack {
                    Text("Mild")
                        .font(AppTheme.caption)
                        .foregroundStyle(AppTheme.mutedText)
                    Spacer()
                    Text("Extreme")
                        .font(AppTheme.caption)
                        .foregroundStyle(AppTheme.mutedText)
                }
                .padding(.horizontal, AppTheme.spacingLG)
            }

            Spacer()
            Spacer()
        }
        .padding(.horizontal, AppTheme.spacingMD)
    }
}
