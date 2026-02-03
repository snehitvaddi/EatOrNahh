import Foundation

protocol ImageGenerationServiceProtocol: Sendable {
    func generateFoodImage(dishName: String, description: String) async throws -> URL
}
