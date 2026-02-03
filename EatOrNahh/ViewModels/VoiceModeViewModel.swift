import SwiftUI
import SwiftData

@Observable
final class VoiceModeViewModel {
    var isListening: Bool = false
    var transcript: String = ""
    var isProcessing: Bool = false
    var error: Error? = nil
    var recommendedItems: [MenuItem] = []

    private let speechService: SpeechService
    private let conversationVM: ConversationViewModel
    private var transcriptTask: Task<Void, Never>?

    init(
        speechService: SpeechService = SpeechService(),
        conversationVM: ConversationViewModel = ConversationViewModel()
    ) {
        self.speechService = speechService
        self.conversationVM = conversationVM
    }

    func startListening() {
        do {
            transcript = ""
            try speechService.startListening()
            isListening = true

            transcriptTask = Task {
                for await text in speechService.transcriptStream() {
                    await MainActor.run {
                        self.transcript = text
                    }
                }
            }
        } catch {
            self.error = error
        }
    }

    func stopAndSend(session: MenuSession, profile: UserProfile, context: ModelContext) async {
        speechService.stopListening()
        isListening = false
        transcriptTask?.cancel()

        let text = transcript.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        isProcessing = true
        conversationVM.inputText = text
        await conversationVM.sendMessage(session: session, profile: profile, context: context)

        // Update recommended items from latest assistant message
        if let lastAssistant = session.messages.last(where: { $0.role == "assistant" }) {
            recommendedItems = session.menuItems.filter { item in
                lastAssistant.recommendedDishIDs.contains(item.id)
            }

            // Speak the response
            await speechService.speak(lastAssistant.content)
        }

        isProcessing = false
        transcript = ""
    }

    func cleanup() {
        speechService.stopListening()
        transcriptTask?.cancel()
        isListening = false
    }
}
