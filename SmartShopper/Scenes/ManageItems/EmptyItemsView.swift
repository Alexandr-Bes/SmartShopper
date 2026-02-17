//
//  EmptyItemsView.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 16.02.2026.
//

import SwiftUI

struct EmptyItemsView: View {

    var onAddItem: (() -> Void)?

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "basket")
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(.secondary)
            Text("No items yet")
                .font(.headline)
            Text("Add your first grocery item and start organizing your list.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button {
                onAddItem?()
            } label: {
                Label("Add New Item", systemImage: "plus.circle.fill")
                    .fontWeight(.semibold)
                    .buttonStyle(.glass)
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 4)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 40)
    }
}

#Preview {
    EmptyItemsView()
}
