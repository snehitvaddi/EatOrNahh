import Foundation
import SwiftData

@Model
final class CuisinePreference {
    @Attribute(.unique) var id: UUID
    var name: String
    var isSelected: Bool

    var profile: UserProfile?

    init(name: String, isSelected: Bool = false) {
        self.id = UUID()
        self.name = name
        self.isSelected = isSelected
    }
}
