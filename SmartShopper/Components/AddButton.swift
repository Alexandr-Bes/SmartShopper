//
//  AddButton.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 14.03.2026.
//

import SwiftUI

struct AddButton: View {
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
        }
        .buttonStyle(.appGradient)
//        .sensoryFeedback(.success, trigger: )
    }
}

#Preview {
    AddButton()
}
