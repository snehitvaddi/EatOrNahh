import Foundation

struct MenuParseResult: Codable, Sendable {
    let restaurantName: String?
    let categories: [MenuCategory]

    struct MenuCategory: Codable, Sendable {
        let name: String
        let items: [ParsedItem]
    }

    struct ParsedItem: Codable, Sendable {
        let name: String
        let description: String?
        let price: String?
        let tags: [String]
        let ingredients: [String]
    }
}
