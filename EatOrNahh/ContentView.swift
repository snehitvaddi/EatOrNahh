import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]
    @State private var appState = AppState()

    var body: some View {
        Group {
            if appState.hasCompletedOnboarding {
                NavigationStack(path: $appState.navigationPath) {
                    HomeView()
                        .navigationDestination(for: AppState.Route.self) { route in
                            switch route {
                            case .home:
                                HomeView()
                            case .menuUpload:
                                MenuUploadView()
                            case .conversation(let sessionID):
                                ConversationView(sessionID: sessionID)
                            case .voiceMode(let sessionID):
                                VoiceModeView(sessionID: sessionID)
                            case .dishDetail(let menuItemID):
                                DishCardExpandedView(menuItemID: menuItemID)
                            case .profile:
                                ProfileView()
                            }
                        }
                }
            } else {
                OnboardingContainerView()
            }
        }
        .environment(appState)
        .onAppear {
            if let profile = profiles.first {
                appState.hasCompletedOnboarding = profile.hasCompletedOnboarding
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [
            UserProfile.self,
            CuisinePreference.self,
            MenuSession.self,
            MenuItem.self,
            ConversationMessage.self,
            SavedDish.self,
        ], inMemory: true)
}
