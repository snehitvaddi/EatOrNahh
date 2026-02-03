import Foundation

enum AppConstants {
    static let openAIBaseURL = "https://api.openai.com/v1"
    static let chatModel = "gpt-4o"
    static let imageModel = "dall-e-3"
    static let imageSize = "1024x1024"
    static let imageQuality = "standard"
    static let maxImageDimension: CGFloat = 2048
    static let imageCompressionQuality: CGFloat = 0.8
    static let maxRecommendationsPerResponse = 5

    enum Cuisine {
        static let all = [
            "Italian", "Japanese", "Mexican", "Indian", "Thai",
            "Chinese", "Korean", "Mediterranean", "American", "Vietnamese",
            "Ethiopian", "French", "Middle Eastern", "Greek", "Caribbean"
        ]
    }

    enum Allergen {
        static let all = [
            "Peanuts", "Tree Nuts", "Shellfish", "Fish", "Dairy",
            "Eggs", "Wheat/Gluten", "Soy", "Sesame"
        ]
    }

    enum DietaryRestriction {
        static let all = [
            "Vegetarian", "Vegan", "Pescatarian", "Halal",
            "Kosher", "Keto", "Low-Carb", "Gluten-Free"
        ]
    }
}
