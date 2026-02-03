import SwiftUI
import SwiftData

struct PastSessionsListView: View {
    @Environment(AppState.self) private var appState
    @Query(sort: \MenuSession.createdAt, order: .reverse) private var sessions: [MenuSession]

    var body: some View {
        ZStack {
            AppTheme.background
                .ignoresSafeArea()

            if sessions.isEmpty {
                VStack(spacing: AppTheme.spacingMD) {
                    Image(systemName: "tray")
                        .font(.largeTitle)
                        .foregroundStyle(AppTheme.mutedText)
                    Text("No past sessions yet")
                        .font(AppTheme.body)
                        .foregroundStyle(AppTheme.mutedText)
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: AppTheme.spacingMD) {
                        ForEach(sessions) { session in
                            Button {
                                appState.navigationPath.append(AppState.Route.conversation(sessionID: session.id))
                            } label: {
                                SessionRowView(session: session)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, AppTheme.spacingMD)
                    .padding(.top, AppTheme.spacingMD)
                }
            }
        }
        .navigationTitle("Past Sessions")
        .navigationBarTitleDisplayMode(.inline)
    }
}
