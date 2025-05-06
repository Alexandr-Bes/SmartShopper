//
//  GroceryRepository.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 05.05.2025.
//

import Foundation

protocol GroceryRepositoryProtocol {
    func getItems() async throws -> [GroceryItem]
    func updateItems(_ items: [GroceryItem])
    func deleteItems(_ ids: [String])
}

final class GroceryRepository: GroceryRepositoryProtocol {

    func getItems() async throws -> [GroceryItem] {
        Log.debug("Preparing to simulate item load...")

        try await Task.sleep(for: .seconds(2)) // Simulated network delay

        let items = [
            GroceryItem(name: "Milk", category: .unCategorized, store: .pingoDoce),
            GroceryItem(name: "Bread", category: .unCategorized, store: .pingoDoce),
            GroceryItem(name: "Apples", category: .fruits, store: .pingoDoce),
            GroceryItem(name: "Eggs", category: .meat, store: .pingoDoce)
        ]

        Log.debug("Simulated loading \(items.count) grocery items")

        return items
    }

    func updateItems(_ items: [GroceryItem]) {
        Log.debug("Simulating update of \(items.count) items:")
//        items.forEach { Log.debug("Updating item: \($0.name)") }
    }

    func deleteItems(_ ids: [String]) {
        Log.debug("Simulating deletion of \(ids.count) items:")
        ids.forEach { Log.debug("Deleting item with id: \($0)") }
    }
}
