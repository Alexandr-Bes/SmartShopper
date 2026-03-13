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

    init(item: GroceryItem, onToggle: @escaping () -> Void) {
        self.item = item
        self.onToggle = onToggle
    }

    var body: some View {
        ZStack(alignment: .trailing) {
            NavigationLink(value: item.id) {
                GroceryItemListRow(item: item, trailingStyle: .none)
            }
            .navigationLinkIndicatorVisibility(.hidden)
            .buttonStyle(.plain)

            Button(action: onToggle) {
                CheckboxView(isChecked: item.isBought)
                    .foregroundStyle(item.isBought ? .green : .secondary)
                    .font(.title2)
            }
            .buttonStyle(.borderless)
            .padding(.trailing, 8)
        }
    }
}

#Preview {
    var item = GroceryItem(name: "Salmon", category: .fish, stores: [], isBought: false)
    GroceryItemRow(item: GroceryItem(name: "Salmon", category: .fish, stores: [])) { }
}
