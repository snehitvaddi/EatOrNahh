import Foundation
import UIKit

final class ImageCacheService: @unchecked Sendable {
    private let memoryCache = NSCache<NSString, NSData>()
    private let cacheDirectory: URL

    init() {
        let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        self.cacheDirectory = caches.appendingPathComponent("GeneratedImages", isDirectory: true)
        try? FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }

    func cacheKey(for dishName: String, description: String) -> String {
        let combined = "\(dishName)|\(description)"
        let hash = combined.data(using: .utf8)!.hashValue
        return "\(abs(hash))"
    }

    func cachedImageURL(for key: String) -> URL? {
        let fileURL = cacheDirectory.appendingPathComponent("\(key).jpg")
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return fileURL
        }
        return nil
    }

    func store(_ data: Data, for key: String) -> URL {
        let fileURL = cacheDirectory.appendingPathComponent("\(key).jpg")
        try? data.write(to: fileURL)
        memoryCache.setObject(data as NSData, forKey: key as NSString)
        return fileURL
    }

    func imageData(for key: String) -> Data? {
        if let cached = memoryCache.object(forKey: key as NSString) {
            return cached as Data
        }
        let fileURL = cacheDirectory.appendingPathComponent("\(key).jpg")
        if let data = try? Data(contentsOf: fileURL) {
            memoryCache.setObject(data as NSData, forKey: key as NSString)
            return data
        }
        return nil
    }
}
