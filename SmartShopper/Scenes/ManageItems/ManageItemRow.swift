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
        HStack(spacing: 12) {
            Text(item.emoji ?? "🛒")
                .font(.title3)
                .frame(width: 36, height: 36)
                .background(Color.blue.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.body.weight(.medium))
                Text(item.stores.map(\.name).joined(separator: ", "))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer(minLength: 12)

            if item.isBought {
                Label("Bought", systemImage: "checkmark.circle.fill")
                    .font(.default)
                    .labelStyle(.iconOnly)
                    .foregroundStyle(.green)
            }
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    ManageItemRow(item: mockItems[1])
}
