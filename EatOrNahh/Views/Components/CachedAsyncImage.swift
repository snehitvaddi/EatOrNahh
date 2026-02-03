import SwiftUI

struct CachedAsyncImage: View {
    let path: String?
    var contentMode: ContentMode = .fill

    var body: some View {
        if let path, let uiImage = UIImage(contentsOfFile: path) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: contentMode)
        } else {
            // Gradient placeholder
            LinearGradient(
                colors: [
                    AppTheme.accent.opacity(0.2),
                    AppTheme.sageGreen.opacity(0.15),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .overlay {
                Image(systemName: "fork.knife")
                    .font(.title2)
                    .foregroundStyle(AppTheme.mutedText.opacity(0.4))
            }
        }
    }
}
