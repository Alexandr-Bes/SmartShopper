//
//  AppButtonStyles.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 14.03.2026.
//

import SwiftUI

struct AppGradientButtonStyle: ButtonStyle {
    @Environment(\.appTheme) private var theme
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.white)
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
            .background {
                Capsule()
                    .fill(backgroundGradient)
                    .overlay {
                        Capsule()
                            .strokeBorder(.white.opacity(0.2), lineWidth: 1)
                    }
            }
            .opacity(isEnabled ? 1 : 0.65)
            .saturation(isEnabled ? 1 : 0)
            .shadow(
                color: Color.black.opacity(configuration.isPressed ? 0.1 : 0.2),
                radius: configuration.isPressed ? 6 : 12,
                y: configuration.isPressed ? 2 : 4
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.snappy(duration: 0.2), value: configuration.isPressed)
    }

    private var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [theme.accentGradientStart, theme.accentGradientEnd],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

extension ButtonStyle where Self == AppGradientButtonStyle {
    static var appGradient: AppGradientButtonStyle {
        AppGradientButtonStyle()
    }
}
