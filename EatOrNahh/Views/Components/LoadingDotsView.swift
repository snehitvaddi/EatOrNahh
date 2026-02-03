import SwiftUI

struct LoadingDotsView: View {
    @State private var animating = false
    let color: Color
    let dotSize: CGFloat

    init(color: Color = AppTheme.accent, dotSize: CGFloat = 8) {
        self.color = color
        self.dotSize = dotSize
    }

    var body: some View {
        HStack(spacing: dotSize * 0.75) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(color)
                    .frame(width: dotSize, height: dotSize)
                    .offset(y: animating ? -dotSize : 0)
                    .animation(
                        .easeInOut(duration: 0.5)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.15),
                        value: animating
                    )
            }
        }
        .onAppear {
            animating = true
        }
    }
}

#Preview {
    LoadingDotsView()
}
