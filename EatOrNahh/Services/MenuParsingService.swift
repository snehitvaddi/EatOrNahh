import Foundation

final class MenuParsingService: MenuParsingServiceProtocol, @unchecked Sendable {
    private let openAI: OpenAIServiceProtocol

    init(openAI: OpenAIServiceProtocol) {
        self.openAI = openAI
    }

    func parseMenuImages(_ images: [Data]) async throws -> MenuParseResult {
        let compressed = images.map { ImageCompressor.compress($0) }

        let prompt = """
        Analyze these restaurant menu images. Extract ALL menu items into structured JSON.

        Return a JSON object with this exact schema:
        {
          "restaurantName": "string or null",
          "categories": [
            {
              "name": "category name (e.g. Appetizers, Entrees, Desserts)",
              "items": [
                {
                  "name": "dish name exactly as written",
                  "description": "description if available, or null",
                  "price": "price as shown (e.g. '$14.99'), or null",
                  "tags": ["spicy", "vegetarian", "popular", "gluten-free", etc.],
                  "ingredients": ["ingredient1", "ingredient2"]
                }
              ]
            }
          ]
        }

        Rules:
        - Extract EVERY item visible on the menu
        - Preserve exact dish names as written
        - Include prices exactly as shown
        - Infer tags from descriptions (e.g. if it says "served with shrimp", add "contains shellfish")
        - If no clear categories, group by type (starters, mains, sides, drinks, desserts)
        - Return valid JSON only, no markdown
        """

        let jsonString = try await openAI.visionAnalysis(images: compressed, prompt: prompt)

        guard let jsonData = jsonString.data(using: .utf8) else {
            throw MenuParseError.invalidJSON
        }

        do {
            return try JSONDecoder().decode(MenuParseResult.self, from: jsonData)
        } catch {
            throw MenuParseError.decodingFailed(error.localizedDescription)
        }
    }
}

enum MenuParseError: LocalizedError {
    case invalidJSON
    case decodingFailed(String)

    var errorDescription: String? {
        switch self {
        case .invalidJSON:
            return "Could not parse the menu data."
        case .decodingFailed(let detail):
            return "Menu parsing failed: \(detail)"
        }
    }
}
