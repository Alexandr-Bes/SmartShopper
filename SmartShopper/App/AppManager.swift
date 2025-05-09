//
//  AppManager.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 05.05.2025.
//

import Observation

enum TabTarget: String {
    case list
    case order
    case manage
}

@Observable
final class AppManager {
    private var actualStore = GroceryStore(name: "Pingo Doce")

    var currentStore: GroceryStore { actualStore }
    var deepLinkTarget: TabTarget?

    func appLaunched() {
        // TODO: - Get data from location or last selected
        actualStore = mockStores.first!
    }
}
