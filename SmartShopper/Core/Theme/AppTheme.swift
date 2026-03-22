//
//  AppTheme.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 22.02.2026.
//

import SwiftUI

struct AppTheme {
    let primary: Color
    let destructive: Color
    let accentTint: Color
    let accentGradientStart: Color
    let accentGradientEnd: Color
    let rowBadgeBackground: Color
    let rowBadgeText: Color

    static let `default` = AppTheme(
        primary: .blue,
        destructive: .red,
        accentTint: .blue,
        accentGradientStart: .blue,
        accentGradientEnd: .mint,
        rowBadgeBackground: Color.blue.opacity(0.15),
        rowBadgeText: .green
    )
}

private struct AppThemeKey: EnvironmentKey {
    static let defaultValue: AppTheme = .default
}

extension EnvironmentValues {
    var appTheme: AppTheme {
        get { self[AppThemeKey.self] }
        set { self[AppThemeKey.self] = newValue }
    }
}

extension View {
    func appTheme(_ theme: AppTheme) -> some View {
        environment(\.appTheme, theme)
    }
}
