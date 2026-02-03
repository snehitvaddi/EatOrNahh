import SwiftUI
import SwiftData

@Observable
final class OnboardingViewModel {
    var spiceTolerance: Double = 2
    var selectedCuisines: Set<String> = []
    var allergies: Set<String> = []
    var dietaryRestrictions: Set<String> = []
    var currentPage: Int = 0

    let totalPages = 5

    var canProceed: Bool {
        switch currentPage {
        case 0: return true  // spice tolerance always valid
        case 1: return !selectedCuisines.isEmpty
        case 2: return true  // allergies optional
        case 3: return true  // restrictions optional
        case 4: return true  // complete page
        default: return true
        }
    }

    var isLastPage: Bool {
        currentPage == totalPages - 1
    }

    func toggleCuisine(_ cuisine: String) {
        if selectedCuisines.contains(cuisine) {
            selectedCuisines.remove(cuisine)
        } else {
            selectedCuisines.insert(cuisine)
        }
    }

    func toggleAllergy(_ allergy: String) {
        if allergies.contains(allergy) {
            allergies.remove(allergy)
        } else {
            allergies.insert(allergy)
        }
    }

    func toggleRestriction(_ restriction: String) {
        if dietaryRestrictions.contains(restriction) {
            dietaryRestrictions.remove(restriction)
        } else {
            dietaryRestrictions.insert(restriction)
        }
    }

    func nextPage() {
        if currentPage < totalPages - 1 {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                currentPage += 1
            }
        }
    }

    func previousPage() {
        if currentPage > 0 {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                currentPage -= 1
            }
        }
    }

    func saveProfile(context: ModelContext, appState: AppState) {
        let profile = UserProfile()
        profile.spiceTolerance = Int(spiceTolerance)
        profile.allergies = Array(allergies)
        profile.dietaryRestrictions = Array(dietaryRestrictions)
        profile.hasCompletedOnboarding = true

        for cuisine in selectedCuisines {
            let pref = CuisinePreference(name: cuisine, isSelected: true)
            profile.cuisinePreferences.append(pref)
        }

        context.insert(profile)

        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            appState.hasCompletedOnboarding = true
        }
    }
}
