import SwiftUI

struct SessionRowView: View {
    let session: MenuSession

    var body: some View {
        HStack(spacing: AppTheme.spacingMD) {
            // Restaurant icon
            ZStack {
                RoundedRectangle(cornerRadius: AppTheme.cornerMD, style: .continuous)
                    .fill(AppTheme.accent.opacity(0.06))
                    .frame(width: 48, height: 48)

                Image(systemName: "fork.knife")
                    .font(.title3)
                    .foregroundStyle(AppTheme.accent)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(session.restaurantName ?? "Unknown Restaurant")
                    .font(AppTheme.headline)
                    .foregroundStyle(AppTheme.deepCharcoal)
                    .lineLimit(1)

                HStack(spacing: AppTheme.spacingSM) {
                    Text(session.createdAt, format: .dateTime.month().day().hour().minute())
                        .font(AppTheme.caption)
                        .foregroundStyle(AppTheme.mutedText)

                    if !session.menuItems.isEmpty {
                        Text("\(session.menuItems.count) items")
                            .font(AppTheme.caption)
                            .foregroundStyle(AppTheme.mutedText)
                    }
                }
            }

            Spacer()

            // Status pill
            Text(session.status.capitalized)
                .font(AppTheme.caption)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(statusColor.opacity(0.12))
                .foregroundStyle(statusColor)
                .clipShape(Capsule())

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(AppTheme.mutedText)
        }
        .padding(AppTheme.spacingMD)
        .cardStyle()
    }

    private var statusColor: Color {
        switch session.status {
        case "completed": return AppTheme.sageGreen
        case "ready": return AppTheme.accent
        default: return AppTheme.mutedText
        }
    }
}
