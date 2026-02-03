import SwiftUI
import SwiftData

@Observable
final class ProfileViewModel {
    var spiceTolerance: Double = 2
    var selectedCuisines: Set<String> = []
    var allergies: Set<String> = []
    var dietaryRestrictions: Set<String> = []

    func loadProfile(_ profile: UserProfile) {
        spiceTolerance = Double(profile.spiceTolerance)
        selectedCuisines = Set(profile.cuisinePreferences.filter(\.isSelected).map(\.name))
        allergies = Set(profile.allergies)
        dietaryRestrictions = Set(profile.dietaryRestrictions)
    }

    func saveProfile(_ profile: UserProfile) {
        profile.spiceTolerance = Int(spiceTolerance)
        profile.allergies = Array(allergies)
        profile.dietaryRestrictions = Array(dietaryRestrictions)
        profile.updatedAt = Date()

        // Update cuisine preferences
        for pref in profile.cuisinePreferences {
            pref.isSelected = selectedCuisines.contains(pref.name)
        }

        // Add new cuisines
        let existingNames = Set(profile.cuisinePreferences.map(\.name))
        for cuisine in selectedCuisines where !existingNames.contains(cuisine) {
            let newPref = CuisinePreference(name: cuisine, isSelected: true)
            profile.cuisinePreferences.append(newPref)
        }
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
}
