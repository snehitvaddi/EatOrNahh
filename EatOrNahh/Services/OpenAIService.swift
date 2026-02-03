import Foundation

final class OpenAIService: OpenAIServiceProtocol, @unchecked Sendable {
    private let apiKey: String
    private let session: URLSession
    private let baseURL: String

    init(apiKey: String = APIKeys.openAIKey, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
        self.baseURL = AppConstants.openAIBaseURL
    }

    func chatCompletion(messages: [ChatRequestMessage], jsonMode: Bool) async throws -> String {
        let request = ChatCompletionRequest(
            model: AppConstants.chatModel,
            messages: messages,
            temperature: 0.7,
            maxTokens: 2048,
            responseFormat: jsonMode ? .json : nil
        )

        let data = try await post(endpoint: "/chat/completions", body: request)
        let response = try JSONDecoder().decode(ChatCompletionResponse.self, from: data)

        guard let content = response.choices.first?.message.content else {
            throw OpenAIError.emptyResponse
        }
        return content
    }

    func visionAnalysis(images: [Data], prompt: String) async throws -> String {
        var parts: [ContentPart] = [.textPart(prompt)]

        for imageData in images {
            let base64 = imageData.base64EncodedString()
            parts.append(.imagePart(base64: base64, detail: "high"))
        }

        let messages: [ChatRequestMessage] = [
            ChatRequestMessage(role: "user", content: .multipart(parts))
        ]

        let request = ChatCompletionRequest(
            model: AppConstants.chatModel,
            messages: messages,
            temperature: 0.3,
            maxTokens: 4096,
            responseFormat: .json
        )

        let data = try await post(endpoint: "/chat/completions", body: request)
        let response = try JSONDecoder().decode(ChatCompletionResponse.self, from: data)

        guard let content = response.choices.first?.message.content else {
            throw OpenAIError.emptyResponse
        }
        return content
    }

    // MARK: - Private

    private func post<T: Encodable>(endpoint: String, body: T) async throws -> Data {
        guard !apiKey.isEmpty else {
            throw OpenAIError.missingAPIKey
        }

        var urlRequest = URLRequest(url: URL(string: baseURL + endpoint)!)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await session.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw OpenAIError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            let errorBody = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw OpenAIError.apiError(statusCode: httpResponse.statusCode, message: errorBody)
        }

        return data
    }
}

enum OpenAIError: LocalizedError {
    case missingAPIKey
    case emptyResponse
    case invalidResponse
    case apiError(statusCode: Int, message: String)

    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "OpenAI API key is not configured."
        case .emptyResponse:
            return "Received an empty response from the AI."
        case .invalidResponse:
            return "Received an invalid response."
        case .apiError(let code, let message):
            return "API error (\(code)): \(message)"
        }
    }
}
