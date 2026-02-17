//
//  GroceryRepository.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 05.05.2025.
//

import Foundation

protocol GroceryRepositoryProtocol {
    func getSelectedStore() -> GroceryStore
    func add(_ item: GroceryItem) async throws
    func getItems() async throws -> [GroceryItem]
    func updateItem(_ item: GroceryItem) async throws
    func deleteItems(_ ids: [String]) async throws
}

final class GroceryRepository: GroceryRepositoryProtocol {

    private let dataSource: GroceryDataSourceProtocol

    init(dataSource: GroceryDataSourceProtocol) {
        self.dataSource = dataSource
    }

    //TODO: - From location / Last selected
    func getSelectedStore() -> GroceryStore {
        return mockStores.first(where: { $0.selected }) ?? mockStores.first!
    }

    func getItems() async throws -> [GroceryItem] {
        try await dataSource.fetchItems()
    }

    func add(_ item: GroceryItem) async throws {
        try await dataSource.addItem(item)
    }

    func updateItem(_ item: GroceryItem) async throws {
        try await dataSource.updateItem(item)
    }

    func deleteItems(_ ids: [String]) async throws {
        ids.forEach { Log.debug("Deleting item with id: \($0)") }
        try await dataSource.deleteItems(ids: ids)
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
/*
extension GroceryRepository {
    func setDefaults(using map: [String: String], store: GroceryStore) async {
        let items: [GroceryItem] = map.map { name, emoji in
            GroceryItem(name: name, category: .unCategorized, stores: [store])
        }
        try? await (dataSource as? SwiftDataGroceryDataSource)?.setDefaultItemsIfNeeded(items)
    }
}
*/
// MARK: - MOCKS

let mockStores: [GroceryStore] = [GroceryStore(name: "Pingo Doce", selected: true),
                                  GroceryStore(name: "Continente")]
let mockItems = [
    GroceryItem(id: "123", name: "Milk", category: .drinks, stores: [mockStores.first!], lastTimeBought: .now),
    GroceryItem(name: "Bread", category: .unCategorized, stores: mockStores, isBought: true, lastTimeBought: .now),
    GroceryItem(name: "Apple", category: .fruits, stores: mockStores),
    GroceryItem(name: "Orange", category: .fruits, stores: mockStores),
    GroceryItem(name: "Chicken", category: .meat, stores: mockStores),
    GroceryItem(name: "Eggs", category: .meat, stores: mockStores),
    GroceryItem(name: "Salmon", category: .fish, stores: [mockStores[1]])
]
