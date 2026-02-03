import SwiftUI

struct TypingIndicatorView: View {
    var body: some View {
        HStack {
            HStack(spacing: AppTheme.spacingXS) {
                LoadingDotsView(color: AppTheme.mutedText, dotSize: 6)
            }
            .padding(.horizontal, AppTheme.spacingMD)
            .padding(.vertical, AppTheme.spacingMD)
            .background(AppTheme.cardSurface)
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: AppTheme.cornerLG,
                    bottomLeadingRadius: AppTheme.cornerSM,
                    bottomTrailingRadius: AppTheme.cornerLG,
                    topTrailingRadius: AppTheme.cornerLG,
                    style: .continuous
                )
            )
            .overlay(
                UnevenRoundedRectangle(
                    topLeadingRadius: AppTheme.cornerLG,
                    bottomLeadingRadius: AppTheme.cornerSM,
                    bottomTrailingRadius: AppTheme.cornerLG,
                    topTrailingRadius: AppTheme.cornerLG,
                    style: .continuous
                )
                .stroke(AppTheme.borderColor, lineWidth: AppTheme.borderWidth)
            )

            Spacer()
        }
    }
}
