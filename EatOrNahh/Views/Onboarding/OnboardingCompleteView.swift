import SwiftUI

struct OnboardingCompleteView: View {
    let viewModel: OnboardingViewModel
    @State private var showCheck = false
    @State private var showContent = false

    var body: some View {
        VStack(spacing: AppTheme.spacingXL) {
            Spacer()

            ZStack {
                Circle()
                    .fill(AppTheme.sageGreen.opacity(0.15))
                    .frame(width: 120, height: 120)
                    .scaleEffect(showCheck ? 1 : 0.3)
                    .opacity(showCheck ? 1 : 0)

                Image(systemName: "checkmark")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(AppTheme.sageGreen)
                    .scaleEffect(showCheck ? 1 : 0.1)
                    .opacity(showCheck ? 1 : 0)
            }
            .animation(.spring(response: 0.6, dampingFraction: 0.6), value: showCheck)

            VStack(spacing: AppTheme.spacingSM) {
                Text("You're all set!")
                    .font(AppTheme.largeTitle)
                    .foregroundStyle(AppTheme.deepCharcoal)

                Text("Here's what we know about you")
                    .font(AppTheme.body)
                    .foregroundStyle(AppTheme.mutedText)
            }
            .opacity(showContent ? 1 : 0)
            .offset(y: showContent ? 0 : 20)

            VStack(spacing: AppTheme.spacingMD) {
                SummaryRow(icon: "flame.fill", label: "Spice level", value: spiceLabel)
                SummaryRow(icon: "fork.knife", label: "Cuisines", value: cuisinesSummary)
                if !viewModel.allergies.isEmpty {
                    SummaryRow(icon: "exclamationmark.triangle.fill", label: "Allergies", value: viewModel.allergies.joined(separator: ", "))
                }
                if !viewModel.dietaryRestrictions.isEmpty {
                    SummaryRow(icon: "leaf.fill", label: "Diet", value: viewModel.dietaryRestrictions.joined(separator: ", "))
                }
            }
            .padding(AppTheme.spacingMD)
            .cardStyle()
            .opacity(showContent ? 1 : 0)
            .offset(y: showContent ? 0 : 30)

            Spacer()
            Spacer()
        }
        .padding(.horizontal, AppTheme.spacingMD)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.1)) {
                showCheck = true
            }
            withAnimation(.easeOut(duration: 0.5).delay(0.4)) {
                showContent = true
            }
        }
    }

    private var spiceLabel: String {
        let labels = ["No spice", "Mild", "Medium", "Spicy", "Very spicy", "Extreme"]
        return labels[Int(viewModel.spiceTolerance)]
    }

    private var cuisinesSummary: String {
        let cuisines = Array(viewModel.selectedCuisines)
        if cuisines.count <= 3 {
            return cuisines.joined(separator: ", ")
        }
        return cuisines.prefix(3).joined(separator: ", ") + " +\(cuisines.count - 3) more"
    }
}

private struct SummaryRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: AppTheme.spacingMD) {
            Image(systemName: icon)
                .font(.body)
                .foregroundStyle(AppTheme.accent)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(AppTheme.caption)
                    .foregroundStyle(AppTheme.mutedText)
                Text(value)
                    .font(AppTheme.body)
                    .foregroundStyle(AppTheme.deepCharcoal)
            }

            Spacer()
        }
    }
}
