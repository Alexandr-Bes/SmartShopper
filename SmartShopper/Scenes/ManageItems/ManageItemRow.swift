//
//  ManageItemRow.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 16.02.2026.
//

import SwiftUI

struct ManageItemRow: View {
    let item: GroceryItem

    var body: some View {
        GroceryItemListRow(item: item, trailingStyle: .boughtBadge)
    }
}

#Preview {
    ManageItemRow(item: mockItems[1])
}
