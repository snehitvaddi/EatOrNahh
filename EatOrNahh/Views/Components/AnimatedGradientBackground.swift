import SwiftUI

struct AnimatedGradientBackground: View {
    @State private var animate = false

    var body: some View {
        LinearGradient(
            colors: [
                AppTheme.accent.opacity(0.05),
                AppTheme.sageGreen.opacity(0.03),
                AppTheme.accent.opacity(0.02),
            ],
            startPoint: animate ? .topLeading : .bottomTrailing,
            endPoint: animate ? .bottomTrailing : .topLeading
        )
        .ignoresSafeArea()
        .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: animate)
        .onAppear { animate = true }
    }
}
