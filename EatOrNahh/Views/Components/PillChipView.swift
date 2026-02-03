import SwiftUI

struct PillChipView: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
        }
        .pillChip(isSelected: isSelected)
        .sensoryFeedback(.selection, trigger: isSelected)
    }
}

#Preview {
    HStack {
        PillChipView(label: "Italian", isSelected: true, action: {})
        PillChipView(label: "Japanese", isSelected: false, action: {})
    }
    .padding()
}
