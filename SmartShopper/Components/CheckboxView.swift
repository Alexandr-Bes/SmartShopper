//
//  CheckboxView.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 09.05.2025.
//

import SwiftUI

struct CheckboxView: View {
    var isChecked: Bool

    var body: some View {
        Image(systemName: isChecked ? "checkmark.square.fill" : "square")
//            .resizable()
            .foregroundStyle(isChecked ? .yellow : .gray)
    }
}

#Preview {
    CheckboxView(isChecked: true)
}
