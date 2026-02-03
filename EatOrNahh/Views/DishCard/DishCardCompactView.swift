import SwiftUI

struct DishCardCompactView: View {
    let item: MenuItem
    var onTap: (() -> Void)? = nil

    var body: some View {
        Button {
            onTap?()
        } label: {
            VStack(alignment: .leading, spacing: 0) {
                // Food image
                CachedAsyncImage(path: item.generatedImageURL)
                    .frame(width: 180, height: 130)
                    .clipped()

                // Content
                VStack(alignment: .leading, spacing: AppTheme.spacingXS) {
                    Text(item.name)
                        .font(AppTheme.headline)
                        .foregroundStyle(AppTheme.deepCharcoal)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    if let price = item.price {
                        Text(price)
                            .font(AppTheme.captionBold)
                            .foregroundStyle(AppTheme.accent)
                    }

                    if !item.tags.isEmpty {
                        HStack(spacing: 4) {
                            ForEach(item.tags.prefix(2), id: \.self) { tag in
                                Text(tag)
                                    .font(.system(size: 10, weight: .medium, design: .rounded))
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(tagColor(tag).opacity(0.12))
                                    .foregroundStyle(tagColor(tag))
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
                .padding(.horizontal, AppTheme.spacingSM)
                .padding(.vertical, AppTheme.spacingSM)
            }
            .frame(width: 180)
            .background(AppTheme.cardSurface)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerLG, style: .continuous))
            .shadow(color: AppTheme.shadowColor, radius: AppTheme.shadowRadius, x: 0, y: AppTheme.shadowY)
        }
        .buttonStyle(.plain)
    }

    private func tagColor(_ tag: String) -> Color {
        switch tag.lowercased() {
        case "spicy", "hot": return .red
        case "vegetarian", "vegan": return AppTheme.sageGreen
        case "popular", "recommended": return AppTheme.accent
        case "gluten-free": return .purple
        default: return AppTheme.mutedText
        }
    }
}
