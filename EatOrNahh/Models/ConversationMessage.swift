import Foundation
import SwiftData

@Model
final class ConversationMessage {
    @Attribute(.unique) var id: UUID
    var role: String
    var content: String
    var timestamp: Date
    var recommendedDishIDs: [UUID]
    var intentTag: String?

    var session: MenuSession?

    init(role: String, content: String) {
        self.id = UUID()
        self.role = role
        self.content = content
        self.timestamp = Date()
        self.recommendedDishIDs = []
    }
}
