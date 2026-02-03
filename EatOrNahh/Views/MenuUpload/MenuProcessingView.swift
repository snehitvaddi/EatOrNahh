import SwiftUI

struct MenuProcessingView: View {
    let message: String

    var body: some View {
        ZStack {
            AnimatedGradientBackground()

            VStack(spacing: AppTheme.spacingXL) {
                ZStack {
                    Circle()
                        .fill(AppTheme.cardSurface)
                        .frame(width: 100, height: 100)
                        .shadow(color: AppTheme.shadowColor, radius: 4)

                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 40))
                        .foregroundStyle(AppTheme.accent)
                        .symbolEffect(.pulse, options: .repeating)
                }

                VStack(spacing: AppTheme.spacingMD) {
                    Text(message)
                        .font(AppTheme.title)
                        .foregroundStyle(AppTheme.deepCharcoal)
                        .contentTransition(.numericText())
                        .animation(.easeInOut, value: message)

                    LoadingDotsView()
                }
            }
        }
    }
}
