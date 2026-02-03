import Foundation
import SwiftData

@Model
final class SavedDish {
    @Attribute(.unique) var id: UUID
    var dishName: String
    var restaurantName: String?
    var imagePath: String?
    var notes: String?
    var rating: Int?
    var savedAt: Date

    var profile: UserProfile?

    init(dishName: String) {
        self.id = UUID()
        self.dishName = dishName
        self.savedAt = Date()
    }
}
