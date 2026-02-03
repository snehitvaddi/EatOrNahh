import SwiftUI

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(AppTheme.cardSurface)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerLG, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cornerLG, style: .continuous)
                    .stroke(AppTheme.borderColor, lineWidth: AppTheme.borderWidth)
            )
            .shadow(color: AppTheme.shadowColor, radius: AppTheme.shadowRadius, x: 0, y: AppTheme.shadowY)
    }
}

struct PillChipModifier: ViewModifier {
    let isSelected: Bool

    func body(content: Content) -> some View {
        content
            .font(AppTheme.captionBold)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(isSelected ? AppTheme.accent : AppTheme.cardSurface)
            .foregroundStyle(isSelected ? .white : AppTheme.deepCharcoal)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(isSelected ? Color.clear : AppTheme.borderColor, lineWidth: isSelected ? 0 : AppTheme.borderWidth)
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isSelected)
    }
}

struct ElevatedCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(AppTheme.cardSurface)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerLG, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cornerLG, style: .continuous)
                    .stroke(AppTheme.borderColor, lineWidth: AppTheme.borderWidth)
            )
            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardModifier())
    }

    func pillChip(isSelected: Bool) -> some View {
        modifier(PillChipModifier(isSelected: isSelected))
    }

    func elevatedCard() -> some View {
        modifier(ElevatedCardModifier())
    }
}
