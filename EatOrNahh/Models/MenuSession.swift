import Foundation
import SwiftData

@Model
final class MenuSession {
    @Attribute(.unique) var id: UUID
    var restaurantName: String?
    var locationLatitude: Double?
    var locationLongitude: Double?
    var menuImagePaths: [String]
    var rawMenuText: String?
    var createdAt: Date
    var status: String

    @Relationship(deleteRule: .cascade, inverse: \ConversationMessage.session)
    var messages: [ConversationMessage]

    @Relationship(deleteRule: .cascade, inverse: \MenuItem.session)
    var menuItems: [MenuItem]

    var profile: UserProfile?

    init() {
        self.id = UUID()
        self.menuImagePaths = []
        self.createdAt = Date()
        self.status = "uploading"
        self.messages = []
        self.menuItems = []
    }
}
