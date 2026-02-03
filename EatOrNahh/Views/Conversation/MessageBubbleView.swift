import SwiftUI

struct MessageBubbleView: View {
    let message: ConversationMessage
    let recommendedItems: [MenuItem]
    var onTapDish: ((MenuItem) -> Void)? = nil

    private var isUser: Bool { message.role == "user" }

    var body: some View {
        VStack(alignment: isUser ? .trailing : .leading, spacing: AppTheme.spacingSM) {
            HStack {
                if isUser { Spacer(minLength: 60) }

                VStack(alignment: isUser ? .trailing : .leading, spacing: AppTheme.spacingSM) {
                    Text(message.content)
                        .font(AppTheme.body)
                        .foregroundStyle(isUser ? .white : AppTheme.deepCharcoal)
                        .padding(.horizontal, AppTheme.spacingMD)
                        .padding(.vertical, AppTheme.spacingMD)
                        .background(isUser ? AppTheme.accent : AppTheme.cardSurface)
                        .clipShape(
                            UnevenRoundedRectangle(
                                topLeadingRadius: AppTheme.cornerLG,
                                bottomLeadingRadius: isUser ? AppTheme.cornerLG : AppTheme.cornerSM,
                                bottomTrailingRadius: isUser ? AppTheme.cornerSM : AppTheme.cornerLG,
                                topTrailingRadius: AppTheme.cornerLG,
                                style: .continuous
                            )
                        )
                        .overlay(
                            UnevenRoundedRectangle(
                                topLeadingRadius: AppTheme.cornerLG,
                                bottomLeadingRadius: isUser ? AppTheme.cornerLG : AppTheme.cornerSM,
                                bottomTrailingRadius: isUser ? AppTheme.cornerSM : AppTheme.cornerLG,
                                topTrailingRadius: AppTheme.cornerLG,
                                style: .continuous
                            )
                            .stroke(isUser ? Color.clear : AppTheme.borderColor, lineWidth: AppTheme.borderWidth)
                        )
                        .shadow(color: isUser ? AppTheme.shadowColor : .clear, radius: 2, x: 0, y: 0.5)

                    Text(message.timestamp, format: .dateTime.hour().minute())
                        .font(.system(size: 10, design: .default))
                        .foregroundStyle(AppTheme.mutedText)
                }

                if !isUser { Spacer(minLength: 60) }
            }

            // Inline dish carousel for recommendations
            if !recommendedItems.isEmpty {
                DishCarouselView(items: recommendedItems, onTapItem: onTapDish)
                    .padding(.horizontal, -AppTheme.spacingMD)
            }
        }
    }
}
