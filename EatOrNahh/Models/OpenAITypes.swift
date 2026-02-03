import Foundation

// MARK: - Chat Completions

struct ChatCompletionRequest: Codable, Sendable {
    let model: String
    let messages: [ChatRequestMessage]
    let temperature: Double?
    let maxTokens: Int?
    let responseFormat: ResponseFormat?

    enum CodingKeys: String, CodingKey {
        case model, messages, temperature
        case maxTokens = "max_tokens"
        case responseFormat = "response_format"
    }
}

struct ChatRequestMessage: Codable, Sendable {
    let role: String
    let content: MessageContent
}

enum MessageContent: Codable, Sendable {
    case text(String)
    case multipart([ContentPart])

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .text(let string):
            try container.encode(string)
        case .multipart(let parts):
            try container.encode(parts)
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let string = try? container.decode(String.self) {
            self = .text(string)
        } else if let parts = try? container.decode([ContentPart].self) {
            self = .multipart(parts)
        } else {
            throw DecodingError.typeMismatch(
                MessageContent.self,
                .init(codingPath: decoder.codingPath, debugDescription: "Expected String or [ContentPart]")
            )
        }
    }
}

struct ContentPart: Codable, Sendable {
    let type: String
    let text: String?
    let imageUrl: ImageURL?

    enum CodingKeys: String, CodingKey {
        case type, text
        case imageUrl = "image_url"
    }

    static func textPart(_ text: String) -> ContentPart {
        ContentPart(type: "text", text: text, imageUrl: nil)
    }

    static func imagePart(base64: String, detail: String = "high") -> ContentPart {
        ContentPart(
            type: "image_url",
            text: nil,
            imageUrl: ImageURL(url: "data:image/jpeg;base64,\(base64)", detail: detail)
        )
    }
}

struct ImageURL: Codable, Sendable {
    let url: String
    let detail: String?
}

struct ResponseFormat: Codable, Sendable {
    let type: String

    static let json = ResponseFormat(type: "json_object")
}

struct ChatCompletionResponse: Codable, Sendable {
    let id: String
    let choices: [Choice]

    struct Choice: Codable, Sendable {
        let message: ResponseMessage
        let finishReason: String?

        enum CodingKeys: String, CodingKey {
            case message
            case finishReason = "finish_reason"
        }
    }

    struct ResponseMessage: Codable, Sendable {
        let role: String
        let content: String?
    }
}

// MARK: - Image Generation (DALL-E)

struct ImageGenerationRequest: Codable, Sendable {
    let model: String
    let prompt: String
    let n: Int
    let size: String
    let quality: String
}

struct ImageGenerationResponse: Codable, Sendable {
    let data: [GeneratedImage]

    struct GeneratedImage: Codable, Sendable {
        let url: String?
        let revisedPrompt: String?

        enum CodingKeys: String, CodingKey {
            case url
            case revisedPrompt = "revised_prompt"
        }
    }
}

// MARK: - Assistant Response DTO

struct AssistantResponse: Codable, Sendable {
    let text: String
    let recommendations: [RecommendationItem]?

    struct RecommendationItem: Codable, Sendable {
        let dishName: String
        let reasoning: String
    }
}
