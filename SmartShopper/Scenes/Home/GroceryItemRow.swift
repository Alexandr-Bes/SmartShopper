//
//  GroceryItemRow.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 09.05.2025.
//

import SwiftUI

struct GroceryItemRow: View {
    var item: GroceryItem
    var onToggle: (() -> Void)?

    init(item: GroceryItem, onToggle: (() -> Void)? = nil) {
        self.item = item
        self.onToggle = onToggle
    }

    var body: some View {
        HStack {
            Text(item.name)
                .padding(.trailing)
            Text(item.emoji ?? "")
            Spacer()
            CheckboxView(isChecked: item.isBought)
                .frame(width: 18, height: 18)
        }
        .padding(.horizontal, 8)
        .contentShape(Rectangle()) // Makes whole row tappable
        .onTapGesture {
            let lightImpact = UIImpactFeedbackGenerator(style: .light)
            lightImpact.impactOccurred()
            onToggle?()
        }
    }
}

#Preview {
    GroceryItemRow(item: GroceryItem(name: "Salmon", category: .fish, stores: []))
}
