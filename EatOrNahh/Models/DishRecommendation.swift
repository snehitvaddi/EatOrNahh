import Foundation

struct DishRecommendation: Codable, Identifiable, Sendable {
    let id: UUID
    let name: String
    let description: String
    let reasoning: String
    let estimatedCalories: Int?
    let priceRange: String?
    let tags: [String]
    let spiceLevel: Int?
    let matchScore: Double

    init(
        name: String,
        description: String = "",
        reasoning: String = "",
        estimatedCalories: Int? = nil,
        priceRange: String? = nil,
        tags: [String] = [],
        spiceLevel: Int? = nil,
        matchScore: Double = 0.0
    ) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.reasoning = reasoning
        self.estimatedCalories = estimatedCalories
        self.priceRange = priceRange
        self.tags = tags
        self.spiceLevel = spiceLevel
        self.matchScore = matchScore
    }
}
