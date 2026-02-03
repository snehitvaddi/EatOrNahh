import SwiftUI
import SwiftData

@Observable
final class HomeViewModel {
    func createNewSession(context: ModelContext, profile: UserProfile) -> MenuSession {
        let session = MenuSession()
        profile.sessions.append(session)
        return session
    }
}
