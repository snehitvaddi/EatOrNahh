import Foundation

final class ImageGenerationService: ImageGenerationServiceProtocol, @unchecked Sendable {
    private let apiKey: String
    private let session: URLSession
    private let cache: ImageCacheService

    init(apiKey: String = APIKeys.openAIKey, cache: ImageCacheService = ImageCacheService(), session: URLSession = .shared) {
        self.apiKey = apiKey
        self.cache = cache
        self.session = session
    }

    func generateFoodImage(dishName: String, description: String) async throws -> URL {
        let key = cache.cacheKey(for: dishName, description: description)

        if let cachedURL = cache.cachedImageURL(for: key) {
            return cachedURL
        }

        let prompt = buildFoodPrompt(dishName: dishName, description: description)
        let request = ImageGenerationRequest(
            model: AppConstants.imageModel,
            prompt: prompt,
            n: 1,
            size: AppConstants.imageSize,
            quality: AppConstants.imageQuality
        )

        let data = try await postImageGeneration(request)
        let response = try JSONDecoder().decode(ImageGenerationResponse.self, from: data)

        guard let imageURLString = response.data.first?.url,
              let imageURL = URL(string: imageURLString) else {
            throw ImageGenError.noImageReturned
        }

        let (imageData, _) = try await session.data(from: imageURL)
        let localURL = cache.store(imageData, for: key)
        return localURL
    }

    private func buildFoodPrompt(dishName: String, description: String) -> String {
        var prompt = "A photorealistic, appetizing overhead photo of \(dishName)."
        if !description.isEmpty {
            prompt += " \(description)."
        }
        prompt += " Professional food photography, soft natural lighting, shallow depth of field, on a clean ceramic plate, restaurant setting. No text or watermarks."
        return prompt
    }

    private func postImageGeneration(_ request: ImageGenerationRequest) async throws -> Data {
        guard !apiKey.isEmpty else {
            throw OpenAIError.missingAPIKey
        }

        let url = URL(string: "\(AppConstants.openAIBaseURL)/images/generations")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)

        let (data, response) = try await session.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            let errorBody = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw ImageGenError.apiError(errorBody)
        }

        return data
    }
}

enum ImageGenError: LocalizedError {
    case noImageReturned
    case apiError(String)

    var errorDescription: String? {
        switch self {
        case .noImageReturned:
            return "No image was generated."
        case .apiError(let message):
            return "Image generation failed: \(message)"
        }
    }
}
