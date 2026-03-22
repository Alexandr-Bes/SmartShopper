//
//  AddButton.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 14.03.2026.
//

import SwiftUI

struct AddButton: View {
    @Environment(\.appTheme) private var theme

    var title: String = Localization.text(.addNewItem)
    var systemImage: String = "plus.circle.fill"
    var onSelected: (() -> Void)?

    var body: some View {
        Button {
            onSelected?()
        } label: {
            Label(title, systemImage: systemImage)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .lineLimit(1)
                .padding(.vertical, 10)
        }
        .buttonStyle(.glassProminent)
        .buttonBorderShape(.capsule)
        .tint(theme.primary)
    }
}

#Preview {
    AddButton()
}
