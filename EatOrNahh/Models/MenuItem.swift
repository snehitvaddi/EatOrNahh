import Foundation
import SwiftData

@Model
final class MenuItem {
    @Attribute(.unique) var id: UUID
    var name: String
    var itemDescription: String?
    var price: String?
    var category: String?
    var tags: [String]
    var estimatedCalories: Int?
    var ingredients: [String]
    var generatedImageURL: String?

    var session: MenuSession?

    init(name: String) {
        self.id = UUID()
        self.name = name
        self.ingredients = []
        self.tags = []
    }
}
