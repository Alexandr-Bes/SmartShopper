//
//  EmptyItemsView.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 16.02.2026.
//

import SwiftUI

struct EmptyItemsView: View {
    var body: some View {
        VStack {
            VStack(spacing: 12) {
                Image(systemName: "basket")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(.secondary)
                Text(Localization.text(.emptyItemsTitle))
                    .font(.headline)
                Text(Localization.text(.emptyItemsSubtitle))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)


            }
            .padding(.vertical, 40)
        }
    }
}

#Preview {
    EmptyItemsView()
}
