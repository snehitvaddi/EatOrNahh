import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) private var appState
    @Query(sort: \MenuSession.createdAt, order: .reverse) private var sessions: [MenuSession]
    @Query private var profiles: [UserProfile]
    @State private var viewModel = HomeViewModel()

    private var profile: UserProfile? { profiles.first }

    var body: some View {
        ZStack {
            AppTheme.background
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: AppTheme.spacingLG) {
                    // Header
                    header

                    // Hero upload CTA
                    uploadButton

                    // Recent sessions
                    if !sessions.isEmpty {
                        recentSessions
                    }
                }
                .padding(.horizontal, AppTheme.spacingMD)
                .padding(.top, AppTheme.spacingSM)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    appState.navigationPath.append(AppState.Route.profile)
                } label: {
                    Image(systemName: "person.circle")
                        .font(.title3)
                        .foregroundStyle(AppTheme.deepCharcoal)
                }
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: AppTheme.spacingSM) {
            Text("EatOrNahh")
                .font(AppTheme.largeTitle)
                .foregroundStyle(AppTheme.deepCharcoal)

            Text("Can't decide? Let us help.")
                .font(AppTheme.body)
                .foregroundStyle(AppTheme.mutedText)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, AppTheme.spacingXXL)
        .padding(.bottom, AppTheme.spacingMD)
    }

    // MARK: - Upload Button

    private var uploadButton: some View {
        Button {
            appState.navigationPath.append(AppState.Route.menuUpload)
        } label: {
            VStack(spacing: AppTheme.spacingMD) {
                ZStack {
                    Circle()
                        .fill(AppTheme.accent.opacity(0.08))
                        .frame(width: 72, height: 72)

                    Image(systemName: "camera.fill")
                        .font(.title)
                        .foregroundStyle(AppTheme.accent)
                }

                Text("Upload a Menu")
                    .font(AppTheme.title)
                    .foregroundStyle(AppTheme.deepCharcoal)

                Text("Take a photo or pick from gallery")
                    .font(AppTheme.caption)
                    .foregroundStyle(AppTheme.mutedText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.spacingXL)
            .background(AppTheme.cardSurface)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerLG, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cornerLG, style: .continuous)
                    .stroke(AppTheme.borderColor, lineWidth: AppTheme.borderWidth)
            )
            .shadow(color: AppTheme.shadowColor, radius: AppTheme.shadowRadius, x: 0, y: AppTheme.shadowY)
        }
    }

    // MARK: - Recent Sessions

    private var recentSessions: some View {
        VStack(alignment: .leading, spacing: AppTheme.spacingMD) {
            Text("Recent Sessions")
                .font(AppTheme.headline)
                .foregroundStyle(AppTheme.deepCharcoal)
                .padding(.horizontal, AppTheme.spacingXS)

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
        }
    }
}
