//
//  GroceryRepository.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 05.05.2025.
//

import Foundation

protocol GroceryRepositoryProtocol {
    func getItems() async throws -> [GroceryItem]
    func updateItem(_ item: GroceryItemProtocol) async throws
    func updateItems(_ items: [GroceryItem]) async throws
    func deleteItems(_ ids: [String]) async throws
}

final class GroceryRepository: GroceryRepositoryProtocol {

    private let dataSource: GroceryDataSourceProtocol

    init(dataSource: GroceryDataSourceProtocol) {
        self.dataSource = dataSource
    }

    func getItems() async throws -> [GroceryItem] {
        let storedItems = try await dataSource.fetchItems() // loadMockItems()
        let groceryItems = storedItems.compactMap { GroceryItem(from: $0) }
        return groceryItems
    }

    func updateItem(_ item: GroceryItemProtocol) async throws {
        try await dataSource.updateItem(item)
    }

    func updateItems(_ items: [GroceryItem]) async throws {
        try await dataSource.updateItems(items)
    }

    func deleteItems(_ ids: [String]) async throws {
        ids.forEach { Log.debug("Deleting item with id: \($0)") }
        try await dataSource.deleteItems(with: ids)
    }
}

private extension GroceryRepository {
    func loadMockItems() async throws -> [GroceryItem] {
        Log.debug("Preparing to simulate item load...")

        try await Task.sleep(for: .seconds(1)) // Simulated network delay

        let items = mockItems
        let result = items.sorted { $0.category < $1.category }

        Log.debug("Simulated loading \(items.count) grocery items")

        return result
    }
}

extension GroceryRepository {
    func setDefaults(using map: [String: String], store: GroceryStore) async {
        let items: [GroceryItem] = map.map { name, emoji in
            GroceryItem(name: name, category: .unCategorized, stores: [store])
        }
        try? await (dataSource as? SwiftDataGroceryDataSource)?.setDefaultItemsIfNeeded(items)
    }
}

// MARK: - MOCKS

let mockStores: [GroceryStore] = [GroceryStore(name: "Pingo Doce"),
                                  GroceryStore(name: "Continente")]
let mockItems = [
    GroceryItem(name: "Milk", category: .drinks, stores: [mockStores.first!]),
    GroceryItem(name: "Bread", category: .unCategorized, stores: mockStores),
    GroceryItem(name: "Apples", category: .fruits, stores: mockStores),
    GroceryItem(name: "Oranges", category: .fruits, stores: mockStores),
    GroceryItem(name: "Chicken", category: .meat, stores: mockStores),
    GroceryItem(name: "Eggs", category: .meat, stores: mockStores)
]
