import Foundation

enum ServiceFactory {
    private static let cache = ImageCacheService()

    static func makeOpenAIService() -> OpenAIServiceProtocol {
        OpenAIService()
    }

    static func makeMenuParser() -> MenuParsingServiceProtocol {
        MenuParsingService(openAI: makeOpenAIService())
    }

    static func makeImageGenerator() -> ImageGenerationServiceProtocol {
        ImageGenerationService(cache: cache)
    }

    static func makeLocationService() -> LocationServiceProtocol {
        LocationService()
    }
}
