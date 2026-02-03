import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) private var appState
    @Query private var profiles: [UserProfile]
    @State private var viewModel = ProfileViewModel()
    @State private var hasLoaded = false

    private var profile: UserProfile? { profiles.first }

    var body: some View {
        ZStack {
            AppTheme.background
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: AppTheme.spacingLG) {
                    // Profile header
                    VStack(spacing: AppTheme.spacingMD) {
                        ZStack {
                            Circle()
                                .fill(AppTheme.accent.opacity(0.12))
                                .frame(width: 80, height: 80)

                            Image(systemName: "person.fill")
                                .font(.largeTitle)
                                .foregroundStyle(AppTheme.accent)
                        }

                        Text("Your Preferences")
                            .font(AppTheme.title)
                            .foregroundStyle(AppTheme.deepCharcoal)
                    }
                    .padding(.top, AppTheme.spacingMD)

                    // Preferences editor
                    PreferencesEditorView(viewModel: viewModel)
                        .padding(AppTheme.spacingMD)
                        .cardStyle()

                    // Save button
                    Button {
                        if let profile {
                            viewModel.saveProfile(profile)
                        }
                    } label: {
                        Text("Save Changes")
                            .font(AppTheme.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(AppTheme.accent)
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerPill, style: .continuous))
                    }
                    .sensoryFeedback(.success, trigger: false)

                    // Saved dishes
                    if let profile, !profile.savedDishes.isEmpty {
                        VStack(alignment: .leading, spacing: AppTheme.spacingMD) {
                            Text("Saved Dishes")
                                .font(AppTheme.headline)
                                .foregroundStyle(AppTheme.deepCharcoal)

                            ForEach(profile.savedDishes) { dish in
                                HStack(spacing: AppTheme.spacingMD) {
                                    if let path = dish.imagePath {
                                        CachedAsyncImage(path: path)
                                            .frame(width: 56, height: 56)
                                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerSM, style: .continuous))
                                    } else {
                                        RoundedRectangle(cornerRadius: AppTheme.cornerSM, style: .continuous)
                                            .fill(AppTheme.accent.opacity(0.1))
                                            .frame(width: 56, height: 56)
                                            .overlay {
                                                Image(systemName: "heart.fill")
                                                    .foregroundStyle(AppTheme.accent)
                                            }
                                    }

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(dish.dishName)
                                            .font(AppTheme.headline)
                                            .foregroundStyle(AppTheme.deepCharcoal)

                                        if let restaurant = dish.restaurantName {
                                            Text(restaurant)
                                                .font(AppTheme.caption)
                                                .foregroundStyle(AppTheme.mutedText)
                                        }
                                    }

                                    Spacer()

                                    Text(dish.savedAt, format: .dateTime.month(.abbreviated).day())
                                        .font(AppTheme.caption)
                                        .foregroundStyle(AppTheme.mutedText)
                                }
                                .padding(AppTheme.spacingSM)
                            }
                        }
                        .padding(AppTheme.spacingMD)
                        .cardStyle()
                    }

                    // Past sessions link
                    NavigationLink(value: AppState.Route.home) {
                        // Use inline navigation
                    }

                    // API Key field (dev only)
                    #if DEBUG
                    VStack(alignment: .leading, spacing: AppTheme.spacingSM) {
                        Text("Developer")
                            .font(AppTheme.headline)
                            .foregroundStyle(AppTheme.deepCharcoal)

                        Text("API key is configured via Info.plist or environment variable")
                            .font(AppTheme.caption)
                            .foregroundStyle(AppTheme.mutedText)
                    }
                    .padding(AppTheme.spacingMD)
                    .cardStyle()
                    #endif
                }
                .padding(.horizontal, AppTheme.spacingMD)
                .padding(.bottom, AppTheme.spacingXL)
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if !hasLoaded, let profile {
                viewModel.loadProfile(profile)
                hasLoaded = true
            }
        }
    }
}
