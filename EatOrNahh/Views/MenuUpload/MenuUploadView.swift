import SwiftUI
import SwiftData
import PhotosUI

struct MenuUploadView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) private var appState
    @Query private var profiles: [UserProfile]
    @State private var viewModel = MenuUploadViewModel()
    @State private var showError = false

    private var profile: UserProfile? { profiles.first }

    var body: some View {
        ZStack {
            AppTheme.background
                .ignoresSafeArea()

            if viewModel.isProcessing {
                MenuProcessingView(message: viewModel.processingMessage)
            } else {
                ScrollView {
                    VStack(spacing: AppTheme.spacingLG) {
                        // Title
                        VStack(spacing: AppTheme.spacingSM) {
                            Text("Upload Menu")
                                .font(AppTheme.largeTitle)
                                .foregroundStyle(AppTheme.deepCharcoal)

                            Text("Add photos of the menu")
                                .font(AppTheme.body)
                                .foregroundStyle(AppTheme.mutedText)
                        }
                        .padding(.top, AppTheme.spacingLG)

                        // Image picker buttons
                        HStack(spacing: AppTheme.spacingMD) {
                            PhotosPicker(
                                selection: $viewModel.selectedPhotosItems,
                                maxSelectionCount: 10,
                                matching: .images
                            ) {
                                VStack(spacing: AppTheme.spacingSM) {
                                    Image(systemName: "photo.on.rectangle.angled")
                                        .font(.title2)
                                    Text("Gallery")
                                        .font(AppTheme.captionBold)
                                }
                                .foregroundStyle(AppTheme.accent)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, AppTheme.spacingLG)
                                .cardStyle()
                            }
                            .onChange(of: viewModel.selectedPhotosItems) {
                                Task { await viewModel.loadImages() }
                            }

                            Button {
                                viewModel.showCamera = true
                            } label: {
                                VStack(spacing: AppTheme.spacingSM) {
                                    Image(systemName: "camera.fill")
                                        .font(.title2)
                                    Text("Camera")
                                        .font(AppTheme.captionBold)
                                }
                                .foregroundStyle(AppTheme.accent)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, AppTheme.spacingLG)
                                .cardStyle()
                            }
                        }

                        // Selected images preview
                        if !viewModel.selectedImages.isEmpty {
                            VStack(alignment: .leading, spacing: AppTheme.spacingMD) {
                                Text("\(viewModel.selectedImages.count) photo(s) selected")
                                    .font(AppTheme.headline)
                                    .foregroundStyle(AppTheme.deepCharcoal)

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: AppTheme.spacingMD) {
                                        ForEach(Array(viewModel.selectedImages.enumerated()), id: \.offset) { index, imageData in
                                            ZStack(alignment: .topTrailing) {
                                                if let uiImage = UIImage(data: imageData) {
                                                    Image(uiImage: uiImage)
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: 120, height: 160)
                                                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerMD, style: .continuous))
                                                }

                                                Button {
                                                    withAnimation(.spring(response: 0.3)) {
                                                        viewModel.removeImage(at: index)
                                                    }
                                                } label: {
                                                    Image(systemName: "xmark.circle.fill")
                                                        .font(.title3)
                                                        .foregroundStyle(.white)
                                                        .shadow(radius: 2)
                                                }
                                                .offset(x: 6, y: -6)
                                            }
                                        }
                                    }
                                    .padding(.horizontal, AppTheme.spacingXS)
                                }
                            }
                        }

                        Spacer(minLength: AppTheme.spacingXL)

                        // Analyze button
                        Button {
                            Task { await analyzeMenu() }
                        } label: {
                            Text("Analyze Menu")
                                .font(AppTheme.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(viewModel.canProcess ? AppTheme.accent : AppTheme.mutedText.opacity(0.3))
                                .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerPill, style: .continuous))
                        }
                        .disabled(!viewModel.canProcess)
                    }
                    .padding(.horizontal, AppTheme.spacingMD)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $viewModel.showCamera) {
            CameraPickerView { data in
                viewModel.addCameraImage(data)
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("Try Again") {
                Task { await analyzeMenu() }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text(viewModel.error?.localizedDescription ?? "Something went wrong")
        }
    }

    private func analyzeMenu() async {
        guard let profile else { return }
        let session = MenuSession()
        profile.sessions.append(session)
        modelContext.insert(session)

        let success = await viewModel.processMenu(session: session, context: modelContext)
        if success {
            appState.navigationPath.append(AppState.Route.conversation(sessionID: session.id))
        } else {
            showError = true
        }
    }
}
