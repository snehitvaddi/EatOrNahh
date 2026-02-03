import SwiftUI

struct WaveformView: View {
    let isActive: Bool
    let barCount: Int

    @State private var animationValues: [CGFloat]

    init(isActive: Bool = true, barCount: Int = 7) {
        self.isActive = isActive
        self.barCount = barCount
        self._animationValues = State(initialValue: Array(repeating: 0.3, count: barCount))
    }

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<barCount, id: \.self) { index in
                RoundedRectangle(cornerRadius: 3)
                    .fill(AppTheme.accent)
                    .frame(width: 4, height: animationValues[index] * 40)
                    .animation(
                        isActive
                            ? .easeInOut(duration: Double.random(in: 0.3...0.7))
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.08)
                            : .easeOut(duration: 0.3),
                        value: animationValues[index]
                    )
            }
        }
        .frame(height: 44)
        .onChange(of: isActive, initial: true) {
            updateAnimation()
        }
    }

    private func updateAnimation() {
        if isActive {
            for i in 0..<barCount {
                animationValues[i] = CGFloat.random(in: 0.3...1.0)
            }
        } else {
            animationValues = Array(repeating: 0.2, count: barCount)
        }
    }
}
