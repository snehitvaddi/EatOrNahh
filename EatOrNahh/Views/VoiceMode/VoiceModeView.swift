import SwiftUI
import SwiftData

struct VoiceModeView: View {
    let sessionID: UUID

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var sessions: [MenuSession]
    @Query private var profiles: [UserProfile]
    @State private var viewModel = VoiceModeViewModel()
    @State private var showDishDetail = false
    @State private var selectedDish: MenuItem? = nil

    private var session: MenuSession? {
        sessions.first { $0.id == sessionID }
    }

    private var profile: UserProfile? {
        profiles.first
    }

    var body: some View {
        ZStack {
            // Dark background
            Color.black.opacity(0.92)
                .ignoresSafeArea()

            VStack(spacing: AppTheme.spacingXL) {
                // Close button
                HStack {
                    Spacer()
                    Button {
                        viewModel.cleanup()
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundStyle(.white.opacity(0.6))
                    }
                }
                .padding(.horizontal, AppTheme.spacingMD)

                Spacer()

                // Status text
                Text(statusText)
                    .font(AppTheme.title)
                    .foregroundStyle(.white)
                    .contentTransition(.numericText())

                // Waveform
                WaveformView(isActive: viewModel.isListening)
                    .frame(height: 60)

                // Live transcript
                LiveTranscriptView(
                    transcript: viewModel.transcript,
                    isListening: viewModel.isListening
                )
                .foregroundStyle(.white)

                Spacer()

                // Dish carousel if we have recommendations
                if !viewModel.recommendedItems.isEmpty {
                    DishCarouselView(items: viewModel.recommendedItems) { dish in
                        selectedDish = dish
                        showDishDetail = true
                    }
                }

                // Mic button
                Button {
                    if viewModel.isListening {
                        Task {
                            if let session, let profile {
                                await viewModel.stopAndSend(session: session, profile: profile, context: modelContext)
                            }
                        }
                    } else {
                        viewModel.startListening()
                    }
                } label: {
                    ZStack {
                        Circle()
                            .fill(viewModel.isListening ? Color.red : AppTheme.accent)
                            .frame(width: 72, height: 72)
                            .shadow(color: (viewModel.isListening ? Color.red : AppTheme.accent).opacity(0.4), radius: 16)

                        Image(systemName: viewModel.isListening ? "stop.fill" : "mic.fill")
                            .font(.title)
                            .foregroundStyle(.white)
                    }
                }
                .sensoryFeedback(.impact(weight: .medium), trigger: viewModel.isListening)
                .disabled(viewModel.isProcessing)

                if viewModel.isProcessing {
                    LoadingDotsView(color: .white)
                }

                Spacer()
                    .frame(height: AppTheme.spacingXL)
            }
        }
        .sheet(isPresented: $showDishDetail) {
            if let dish = selectedDish {
                DishCardExpandedView(menuItemID: dish.id)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
        }
        .onDisappear {
            viewModel.cleanup()
        }
    }

    private var statusText: String {
        if viewModel.isProcessing {
            return "Thinking..."
        } else if viewModel.isListening {
            return "I'm listening..."
        } else {
            return "Tap to speak"
        }
    }
}
