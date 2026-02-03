import SwiftUI
import SwiftData

struct DishCardExpandedView: View {
    let menuItemID: UUID
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var profiles: [UserProfile]
    @State private var saved = false

    @Query private var allItems: [MenuItem]

    private var item: MenuItem? {
        allItems.first { $0.id == menuItemID }
    }

    var body: some View {
        if let item {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Hero image
                    CachedAsyncImage(path: item.generatedImageURL)
                        .frame(height: 300)
                        .frame(maxWidth: .infinity)
                        .clipped()

                    VStack(alignment: .leading, spacing: AppTheme.spacingMD) {
                        // Name & price
                        HStack(alignment: .top) {
                            Text(item.name)
                                .font(AppTheme.largeTitle)
                                .foregroundStyle(AppTheme.deepCharcoal)

                            Spacer()

                            if let price = item.price {
                                Text(price)
                                    .font(AppTheme.title)
                                    .foregroundStyle(AppTheme.accent)
                            }
                        }

                        // Tags
                        if !item.tags.isEmpty {
                            FlowLayout(spacing: 8) {
                                ForEach(item.tags, id: \.self) { tag in
                                    Text(tag)
                                        .pillChip(isSelected: false)
                                }
                            }
                        }

                        // Description
                        if let description = item.itemDescription, !description.isEmpty {
                            Text(description)
                                .font(AppTheme.body)
                                .foregroundStyle(AppTheme.deepCharcoal.opacity(0.8))
                        }

                        // Calories
                        if let calories = item.estimatedCalories {
                            HStack(spacing: AppTheme.spacingSM) {
                                Image(systemName: "flame.fill")
                                    .foregroundStyle(AppTheme.accent)
                                Text("\(calories) cal (est.)")
                                    .font(AppTheme.body)
                                    .foregroundStyle(AppTheme.mutedText)
                            }
                        }

                        // Ingredients
                        if !item.ingredients.isEmpty {
                            VStack(alignment: .leading, spacing: AppTheme.spacingSM) {
                                Text("Ingredients")
                                    .font(AppTheme.headline)
                                    .foregroundStyle(AppTheme.deepCharcoal)

                                Text(item.ingredients.joined(separator: ", "))
                                    .font(AppTheme.body)
                                    .foregroundStyle(AppTheme.mutedText)
                            }
                        }

                        // Category
                        if let category = item.category {
                            HStack(spacing: AppTheme.spacingSM) {
                                Image(systemName: "tag.fill")
                                    .foregroundStyle(AppTheme.sageGreen)
                                Text(category)
                                    .font(AppTheme.body)
                                    .foregroundStyle(AppTheme.mutedText)
                            }
                        }

                        // Save button
                        Button {
                            saveDish(item)
                        } label: {
                            HStack {
                                Image(systemName: saved ? "heart.fill" : "heart")
                                Text(saved ? "Saved" : "Save Dish")
                            }
                            .font(AppTheme.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(saved ? AppTheme.sageGreen : AppTheme.accent)
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerPill, style: .continuous))
                        }
                        .sensoryFeedback(.success, trigger: saved)
                        .padding(.top, AppTheme.spacingSM)
                    }
                    .padding(AppTheme.spacingMD)
                }
            }
            .background(AppTheme.background)
            .overlay(alignment: .topTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .shadow(radius: 4)
                }
                .padding()
            }
        } else {
            VStack {
                Text("Dish not found")
                    .font(AppTheme.title)
                    .foregroundStyle(AppTheme.mutedText)
            }
        }
    }

    private func saveDish(_ item: MenuItem) {
        guard let profile = profiles.first else { return }
        let dish = SavedDish(dishName: item.name)
        dish.restaurantName = item.session?.restaurantName
        dish.imagePath = item.generatedImageURL
        profile.savedDishes.append(dish)
        saved = true
    }
}
