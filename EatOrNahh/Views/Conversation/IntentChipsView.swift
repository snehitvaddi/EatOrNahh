import SwiftUI

struct IntentChipsView: View {
    let onSelect: (String) -> Void

    private let intents = [
        (label: "Adventurous", icon: "sparkles", message: "I'm feeling adventurous today! Surprise me with something unique."),
        (label: "Classic Comfort", icon: "heart.fill", message: "I'm in the mood for something classic and comforting."),
        (label: "Most Popular", icon: "star.fill", message: "What's the most popular dish here?"),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.spacingSM) {
            Text("How are you feeling?")
                .font(AppTheme.caption)
                .foregroundStyle(AppTheme.mutedText)
                .padding(.horizontal, AppTheme.spacingMD)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppTheme.spacingSM) {
                    ForEach(intents, id: \.label) { intent in
                        Button {
                            onSelect(intent.message)
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: intent.icon)
                                    .font(.caption)
                                Text(intent.label)
                                    .font(AppTheme.captionBold)
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(AppTheme.cardSurface)
                            .foregroundStyle(AppTheme.deepCharcoal)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(AppTheme.borderColor, lineWidth: AppTheme.borderWidth))
                        }
                    }
                }
                .padding(.horizontal, AppTheme.spacingMD)
            }
        }
    }
}
