//
//  GroceryItemRow.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 09.05.2025.
//

import SwiftUI

struct GroceryItemRow: View {
    var item: GroceryItem
    var onToggle: () -> Void

    var body: some View {
        HStack {
            Text(item.name)
                .padding(.trailing)
            Text(item.emoji ?? "")
            Spacer()
            CheckboxView(isChecked: item.isBought, onToggle: onToggle)
        }
    }
}

#Preview {
    GroceryItemRow(item: GroceryItem(name: "Salmon", category: .fish, stores: [])) {

    }
}
