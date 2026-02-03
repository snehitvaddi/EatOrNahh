import Foundation

protocol SpeechServiceProtocol {
    var isListening: Bool { get }
    func startListening() throws
    func stopListening()
    func speak(_ text: String) async
    func transcriptStream() -> AsyncStream<String>
}
