import Foundation

enum APIKeys {
    static var openAIKey: String {
        if let key = Bundle.main.infoDictionary?["OPENAI_API_KEY"] as? String, !key.isEmpty {
            return key
        }
        if let key = ProcessInfo.processInfo.environment["OPENAI_API_KEY"], !key.isEmpty {
            return key
        }
        // Set via Xcode scheme environment variable
        return ""
    }
}
