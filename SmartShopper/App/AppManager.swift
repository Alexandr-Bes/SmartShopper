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
    var currentStore: GroceryStore = .pingoDoce
    var deepLinkTarget: TabTarget?

}
