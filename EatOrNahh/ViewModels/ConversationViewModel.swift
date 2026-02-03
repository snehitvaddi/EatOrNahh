import SwiftUI
import SwiftData

@Observable
final class ConversationViewModel {
    var inputText: String = ""
    var isLoading: Bool = false
    var showIntentChips: Bool = true
    var selectedDishForDetail: MenuItem? = nil

    private let openAI: OpenAIServiceProtocol
    private let imageGen: ImageGenerationServiceProtocol

    init(
        openAI: OpenAIServiceProtocol = ServiceFactory.makeOpenAIService(),
        imageGen: ImageGenerationServiceProtocol = ServiceFactory.makeImageGenerator()
    ) {
        self.openAI = openAI
        self.imageGen = imageGen
    }

    func sendMessage(session: MenuSession, profile: UserProfile, context: ModelContext) async {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        let userMsg = ConversationMessage(role: "user", content: text)
        session.messages.append(userMsg)
        inputText = ""
        isLoading = true
        showIntentChips = false

        let systemPrompt = buildSystemPrompt(profile: profile, session: session)
        let chatMessages = buildChatMessages(system: systemPrompt, history: session.messages)

        do {
            let response = try await openAI.chatCompletion(messages: chatMessages, jsonMode: true)
            let parsed = parseAssistantResponse(response)

            let assistantMsg = ConversationMessage(role: "assistant", content: parsed.text)

            if let recs = parsed.recommendations, !recs.isEmpty {
                let matchedItems = matchDishes(recs, in: session.menuItems)
                assistantMsg.recommendedDishIDs = matchedItems.map { $0.id }

                // Generate images in parallel
                await withTaskGroup(of: Void.self) { group in
                    for item in matchedItems where item.generatedImageURL == nil {
                        group.addTask { [imageGen] in
                            if let url = try? await imageGen.generateFoodImage(
                                dishName: item.name,
                                description: item.itemDescription ?? ""
                            ) {
                                await MainActor.run {
                                    item.generatedImageURL = url.path
                                }
                            }
                        }
                    }
                }
            }

            session.messages.append(assistantMsg)
        } catch {
            let errorMsg = ConversationMessage(
                role: "assistant",
                content: "Sorry, I had trouble with that. Could you try again?"
            )
            session.messages.append(errorMsg)
        }

        isLoading = false
    }

    func sendIntent(_ message: String, session: MenuSession, profile: UserProfile, context: ModelContext) async {
        inputText = message
        await sendMessage(session: session, profile: profile, context: context)
    }

    // MARK: - Private

    private func buildSystemPrompt(profile: UserProfile, session: MenuSession) -> String {
        let cuisines = profile.cuisinePreferences.filter(\.isSelected).map(\.name).joined(separator: ", ")
        let allergies = profile.allergies.joined(separator: ", ")
        let restrictions = profile.dietaryRestrictions.joined(separator: ", ")
        let menuDescription = session.menuItems.map { item in
            var line = "- \(item.name)"
            if let desc = item.itemDescription { line += ": \(desc)" }
            if let price = item.price { line += " [\(price)]" }
            if !item.tags.isEmpty { line += " (\(item.tags.joined(separator: ", ")))" }
            return line
        }.joined(separator: "\n")

        return """
        You are a friendly, opinionated food recommendation assistant for "EatOrNahh".
        Your personality: warm, decisive, a bit playful. Help the user CHOOSE, don't just list.

        USER PREFERENCES:
        - Spice tolerance: \(profile.spiceTolerance)/5
        - Favorite cuisines: \(cuisines.isEmpty ? "not specified" : cuisines)
        - Allergies: \(allergies.isEmpty ? "none" : allergies)
        - Dietary restrictions: \(restrictions.isEmpty ? "none" : restrictions)

        RESTAURANT: \(session.restaurantName ?? "Unknown")

        MENU ITEMS:
        \(menuDescription.isEmpty ? "No items parsed yet" : menuDescription)

        RESPONSE FORMAT — Always respond in valid JSON:
        {
          "text": "your conversational message to the user",
          "recommendations": [
            {"dishName": "exact menu item name", "reasoning": "brief reason"}
          ]
        }

        RULES:
        1. NEVER recommend items containing the user's allergens
        2. Respect dietary restrictions absolutely
        3. Factor spice tolerance into recommendations
        4. Limit recommendations to 3-5 dishes per response
        5. If the user asks a general question (not requesting a recommendation), set recommendations to null or empty array
        6. Use the exact dish name as it appears on the menu
        7. Be conversational and helpful, not robotic
        """
    }

    private func buildChatMessages(system: String, history: [ConversationMessage]) -> [ChatRequestMessage] {
        var messages: [ChatRequestMessage] = [
            ChatRequestMessage(role: "system", content: .text(system))
        ]

        for msg in history {
            messages.append(ChatRequestMessage(role: msg.role, content: .text(msg.content)))
        }

        return messages
    }

    private func parseAssistantResponse(_ json: String) -> AssistantResponse {
        guard let data = json.data(using: .utf8),
              let response = try? JSONDecoder().decode(AssistantResponse.self, from: data) else {
            return AssistantResponse(text: json, recommendations: nil)
        }
        return response
    }

    private func matchDishes(_ recommendations: [AssistantResponse.RecommendationItem], in menuItems: [MenuItem]) -> [MenuItem] {
        var matched: [MenuItem] = []
        for rec in recommendations {
            let lowered = rec.dishName.lowercased()
            if let item = menuItems.first(where: { $0.name.lowercased() == lowered }) {
                matched.append(item)
            } else if let item = menuItems.first(where: { $0.name.lowercased().contains(lowered) || lowered.contains($0.name.lowercased()) }) {
                matched.append(item)
            }
        }
        return matched
    }
}
