import SwiftUI

struct DishCarouselView: View {
    let items: [MenuItem]
    var onTapItem: ((MenuItem) -> Void)? = nil

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppTheme.spacingMD) {
                ForEach(items) { item in
                    DishCardCompactView(item: item) {
                        onTapItem?(item)
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.horizontal, AppTheme.spacingMD)
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .frame(height: 220)
    }
}
