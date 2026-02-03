import Foundation

protocol OpenAIServiceProtocol: Sendable {
    func chatCompletion(messages: [ChatRequestMessage], jsonMode: Bool) async throws -> String
    func visionAnalysis(images: [Data], prompt: String) async throws -> String
}
