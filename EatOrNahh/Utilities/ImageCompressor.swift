import UIKit

enum ImageCompressor {
    static func compress(_ data: Data, maxDimension: CGFloat = AppConstants.maxImageDimension, quality: CGFloat = AppConstants.imageCompressionQuality) -> Data {
        guard let image = UIImage(data: data) else { return data }

        let size = image.size
        let scale: CGFloat

        if max(size.width, size.height) > maxDimension {
            scale = maxDimension / max(size.width, size.height)
        } else {
            scale = 1.0
        }

        let newSize = CGSize(width: size.width * scale, height: size.height * scale)

        let renderer = UIGraphicsImageRenderer(size: newSize)
        let resized = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }

        return resized.jpegData(compressionQuality: quality) ?? data
    }
}
