//
//  SmartShopperApp.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 05.05.2025.
//

import SwiftUI

@main
struct SmartShopperApp: App {
    @State private var appManager = AppManager()

    var body: some Scene {
        WindowGroup {
            TabsView()
                .environment(appManager)
                .onOpenURL(perform: handleDeepLink)
        }
    }

    private func handleDeepLink(_ url: URL) {
        guard let host = url.host else { return }
        if let target = TabTarget(rawValue: host) {
            appManager.deepLinkTarget = target
        }
    }
}
