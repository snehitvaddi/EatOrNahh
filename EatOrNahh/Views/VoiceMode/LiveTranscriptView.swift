import SwiftUI

struct LiveTranscriptView: View {
    let transcript: String
    let isListening: Bool

    var body: some View {
        VStack(spacing: AppTheme.spacingSM) {
            if transcript.isEmpty && isListening {
                Text("Listening...")
                    .font(AppTheme.body)
                    .foregroundStyle(AppTheme.mutedText)
                    .italic()
            } else {
                Text(transcript)
                    .font(AppTheme.body)
                    .foregroundStyle(AppTheme.deepCharcoal)
                    .multilineTextAlignment(.center)
                    .contentTransition(.numericText())
                    .animation(.easeOut(duration: 0.15), value: transcript)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, AppTheme.spacingLG)
    }
}
