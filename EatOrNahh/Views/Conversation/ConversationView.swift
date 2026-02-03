import SwiftUI
import SwiftData

struct ConversationView: View {
    let sessionID: UUID

    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) private var appState
    @Query private var sessions: [MenuSession]
    @Query private var profiles: [UserProfile]
    @State private var viewModel = ConversationViewModel()
    @State private var showDishDetail = false
    @FocusState private var isInputFocused: Bool

    private var session: MenuSession? {
        sessions.first { $0.id == sessionID }
    }

    private var profile: UserProfile? {
        profiles.first
    }

    var body: some View {
        ZStack {
            AppTheme.background
                .ignoresSafeArea()

            if let session {
                VStack(spacing: 0) {
                    // Messages
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVStack(spacing: AppTheme.spacingMD) {
                                // Welcome message if empty
                                if session.messages.isEmpty {
                                    welcomeHeader(session: session)
                                }

                                ForEach(session.messages) { message in
                                    let recommendedItems = session.menuItems.filter { item in
                                        message.recommendedDishIDs.contains(item.id)
                                    }

                                    MessageBubbleView(
                                        message: message,
                                        recommendedItems: recommendedItems,
                                        onTapDish: { dish in
                                            viewModel.selectedDishForDetail = dish
                                            showDishDetail = true
                                        }
                                    )
                                    .id(message.id)
                                    .transition(.move(edge: .bottom).combined(with: .opacity))
                                }

                                if viewModel.isLoading {
                                    TypingIndicatorView()
                                        .id("typing")
                                        .transition(.opacity)
                                }
                            }
                            .padding(.horizontal, AppTheme.spacingMD)
                            .padding(.top, AppTheme.spacingMD)
                            .padding(.bottom, AppTheme.spacingLG)
                        }
                        .onChange(of: session.messages.count) {
                            withAnimation(.spring(response: 0.3)) {
                                if let lastID = session.messages.last?.id {
                                    proxy.scrollTo(lastID, anchor: .bottom)
                                }
                            }
                        }
                        .onChange(of: viewModel.isLoading) {
                            if viewModel.isLoading {
                                withAnimation {
                                    proxy.scrollTo("typing", anchor: .bottom)
                                }
                            }
                        }
                    }

                    // Intent chips
                    if viewModel.showIntentChips && session.messages.isEmpty {
                        IntentChipsView { [session] message in
                            Task {
                                guard let profile else { return }
                                await viewModel.sendIntent(message, session: session, profile: profile, context: modelContext)
                            }
                        }
                        .padding(.bottom, AppTheme.spacingSM)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }

                    // Input bar
                    inputBar
                }
            } else {
                Text("Session not found")
                    .font(AppTheme.title)
                    .foregroundStyle(AppTheme.mutedText)
            }
        }
        .navigationTitle(session?.restaurantName ?? "Chat")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    if let session {
                        appState.navigationPath.append(AppState.Route.voiceMode(sessionID: session.id))
                    }
                } label: {
                    Image(systemName: "mic.fill")
                        .foregroundStyle(AppTheme.accent)
                }
            }
        }
        .sheet(isPresented: $showDishDetail) {
            if let dish = viewModel.selectedDishForDetail {
                DishCardExpandedView(menuItemID: dish.id)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
        }
        .animation(.spring(response: 0.3), value: session?.messages.count ?? 0)
    }

    // MARK: - Welcome Header

    private func welcomeHeader(session: MenuSession) -> some View {
        VStack(spacing: AppTheme.spacingMD) {
            Image(systemName: "sparkles")
                .font(.largeTitle)
                .foregroundStyle(AppTheme.accent)

            Text("Ready to help you decide!")
                .font(AppTheme.title)
                .foregroundStyle(AppTheme.deepCharcoal)

            if !session.menuItems.isEmpty {
                Text("\(session.menuItems.count) items found on the menu")
                    .font(AppTheme.body)
                    .foregroundStyle(AppTheme.mutedText)
            }

            Text("Tell me how you're feeling, or tap a mood below")
                .font(AppTheme.caption)
                .foregroundStyle(AppTheme.mutedText)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, AppTheme.spacingXXL)
    }

    // MARK: - Input Bar

    private var inputBar: some View {
        HStack(spacing: AppTheme.spacingMD) {
            TextField("Ask me anything...", text: $viewModel.inputText, axis: .vertical)
                .font(AppTheme.body)
                .lineLimit(1...4)
                .padding(.horizontal, AppTheme.spacingMD)
                .padding(.vertical, AppTheme.spacingSM)
                .background(AppTheme.cardSurface)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerPill, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.cornerPill, style: .continuous)
                        .stroke(AppTheme.borderColor, lineWidth: AppTheme.borderWidth)
                )
                .focused($isInputFocused)

            Button {
                Task {
                    if let session, let profile {
                        await viewModel.sendMessage(session: session, profile: profile, context: modelContext)
                    }
                }
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title2)
                    .foregroundStyle(
                        viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                            ? AppTheme.mutedText.opacity(0.3)
                            : AppTheme.accent
                    )
            }
            .disabled(viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isLoading)
        }
        .padding(.horizontal, AppTheme.spacingMD)
        .padding(.vertical, AppTheme.spacingSM)
        .background(AppTheme.background)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(AppTheme.borderColor)
                .frame(height: 0.5)
        }
    }
}
