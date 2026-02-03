import Foundation

protocol MenuParsingServiceProtocol: Sendable {
    func parseMenuImages(_ images: [Data]) async throws -> MenuParseResult
}
