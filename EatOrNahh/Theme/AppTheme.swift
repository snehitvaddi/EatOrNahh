import SwiftUI

enum AppTheme {
    // MARK: - Colors
    static let background = Color("Background")
    static let accent = Color("AccentColor")
    static let sageGreen = Color("SageGreen")
    static let cardSurface = Color("CardSurface")
    static let deepCharcoal = Color("DeepCharcoal")
    static let mutedText = Color("MutedText")
    static let borderColor = Color.black.opacity(0.08)
    static let borderWidth: CGFloat = 0.5

    // MARK: - Typography
    static let largeTitle = Font.system(.largeTitle, design: .default, weight: .bold)
    static let title = Font.system(.title2, design: .default, weight: .semibold)
    static let headline = Font.system(.headline, design: .default, weight: .medium)
    static let body = Font.system(.body, design: .default)
    static let caption = Font.system(.caption, design: .default)
    static let captionBold = Font.system(.caption, design: .default, weight: .semibold)

    // MARK: - Spacing
    static let spacingXS: CGFloat = 4
    static let spacingSM: CGFloat = 8
    static let spacingMD: CGFloat = 16
    static let spacingLG: CGFloat = 24
    static let spacingXL: CGFloat = 32
    static let spacingXXL: CGFloat = 40

    // MARK: - Corner Radii
    static let cornerSM: CGFloat = 8
    static let cornerMD: CGFloat = 12
    static let cornerLG: CGFloat = 16
    static let cornerPill: CGFloat = 20

    // MARK: - Shadows
    static let shadowColor = Color.black.opacity(0.03)
    static let shadowRadius: CGFloat = 4
    static let shadowY: CGFloat = 1
}
