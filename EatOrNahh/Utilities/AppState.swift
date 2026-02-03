import SwiftUI

@Observable
final class AppState {
    var hasCompletedOnboarding: Bool = false
    var activeSessionID: UUID? = nil
    var navigationPath = NavigationPath()

    enum Route: Hashable {
        case home
        case menuUpload
        case conversation(sessionID: UUID)
        case voiceMode(sessionID: UUID)
        case dishDetail(menuItemID: UUID)
        case profile
    }
}
