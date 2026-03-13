//
//  SmartShopperApp.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 05.05.2025.
//

import SwiftUI
import SwiftData

@main
struct SmartShopperApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var appManager: AppManager?
    @State private var isLoading = true

    var body: some View {
        Group {
            if let manager = appManager {
                TabsView(appManager: manager)
                    .environment(manager)
                    .appTheme(.default)
                    .tint(AppTheme.default.accentTint)
                    .onOpenURL(perform: handleDeepLink)
                    .onAppear {
                        Task {
                            await manager.appLaunched()
                        }
                    }
            } else {
                SplashView()
            }
        }
        .task {
            await loadAppManager()
        }
    }

    private func loadAppManager() async {
        appManager = await AppManagerFactory.make()
        isLoading = false
    }

    private func handleDeepLink(_ url: URL) {
        if let route = DeepLinkRoute.parse(url: url) {
            appManager?.deepLinkRoute = route

            switch route {
            case let .tab(tab):
                appManager?.deepLinkTarget = tab
            case .homeItemDetails:
                appManager?.deepLinkTarget = .list
            case .manageItemDetails:
                appManager?.deepLinkTarget = .manage
            case .search:
                appManager?.deepLinkTarget = .search
            }
        }
    }
}

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack {
                ProgressView()
                Text("Loading your groceries...")
            }
        }
    }
}

#Preview {
    SplashView()
}
