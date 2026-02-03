import Foundation
import SwiftData

@Model
final class UserProfile {
    @Attribute(.unique) var id: UUID
    var spiceTolerance: Int
    var dietaryRestrictions: [String]
    var allergies: [String]
    var createdAt: Date
    var updatedAt: Date
    var hasCompletedOnboarding: Bool

    @Relationship(deleteRule: .cascade, inverse: \CuisinePreference.profile)
    var cuisinePreferences: [CuisinePreference]

    @Relationship(deleteRule: .cascade, inverse: \MenuSession.profile)
    var sessions: [MenuSession]

    @Relationship(deleteRule: .cascade, inverse: \SavedDish.profile)
    var savedDishes: [SavedDish]

    init() {
        self.id = UUID()
        self.spiceTolerance = 2
        self.dietaryRestrictions = []
        self.allergies = []
        self.createdAt = Date()
        self.updatedAt = Date()
        self.hasCompletedOnboarding = false
        self.cuisinePreferences = []
        self.sessions = []
        self.savedDishes = []
    }
}
