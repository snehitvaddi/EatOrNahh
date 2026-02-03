import SwiftUI
import SwiftData
import PhotosUI

@Observable
final class MenuUploadViewModel {
    var selectedPhotosItems: [PhotosPickerItem] = []
    var selectedImages: [Data] = []
    var isProcessing: Bool = false
    var processingMessage: String = ""
    var error: Error? = nil
    var showCamera: Bool = false

    private let menuParser: MenuParsingServiceProtocol
    private let locationService: LocationServiceProtocol

    private let processingMessages = [
        "Reading the menu...",
        "Spotting the specials...",
        "Checking the flavors...",
        "Almost there...",
    ]

    init(
        menuParser: MenuParsingServiceProtocol = ServiceFactory.makeMenuParser(),
        locationService: LocationServiceProtocol = ServiceFactory.makeLocationService()
    ) {
        self.menuParser = menuParser
        self.locationService = locationService
    }

    var canProcess: Bool {
        !selectedImages.isEmpty && !isProcessing
    }

    func loadImages() async {
        var loaded: [Data] = []
        for item in selectedPhotosItems {
            if let data = try? await item.loadTransferable(type: Data.self) {
                loaded.append(data)
            }
        }
        selectedImages = loaded
    }

    func addCameraImage(_ data: Data) {
        selectedImages.append(data)
    }

    func removeImage(at index: Int) {
        guard index < selectedImages.count else { return }
        selectedImages.remove(at: index)
    }

    func processMenu(session: MenuSession, context: ModelContext) async -> Bool {
        isProcessing = true
        error = nil

        // Cycle through fun messages
        let messageTask = Task {
            for (index, message) in processingMessages.enumerated() {
                if Task.isCancelled { break }
                processingMessage = message
                if index < processingMessages.count - 1 {
                    try? await Task.sleep(for: .seconds(2))
                }
            }
        }

        // Try to get location in background
        Task {
            if let location = try? await locationService.requestCurrentLocation() {
                session.locationLatitude = location.coordinate.latitude
                session.locationLongitude = location.coordinate.longitude
                if let name = try? await locationService.reverseGeocode(location) {
                    if session.restaurantName == nil {
                        session.restaurantName = name
                    }
                }
            }
        }

        do {
            let result = try await menuParser.parseMenuImages(selectedImages)

            messageTask.cancel()

            if let name = result.restaurantName {
                session.restaurantName = name
            }
            session.status = "ready"

            for category in result.categories {
                for item in category.items {
                    let menuItem = MenuItem(name: item.name)
                    menuItem.itemDescription = item.description
                    menuItem.price = item.price
                    menuItem.category = category.name
                    menuItem.tags = item.tags
                    menuItem.ingredients = item.ingredients
                    session.menuItems.append(menuItem)
                }
            }

            isProcessing = false
            return true
        } catch {
            messageTask.cancel()
            self.error = error
            isProcessing = false
            return false
        }
    }
}
