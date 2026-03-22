//
//  PreviewMockedData.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 14.05.2025.
//

import Foundation
import SwiftData

@MainActor
final class PreviewMockedDataSource: GroceryDataSourceProtocol {

    private var store: [GroceryItem]

    init(initial: [GroceryItem] = []) {
        self.store = initial
    }

    func fetchItems() async throws -> [GroceryItem] {
        store
    }

    func addItem(_ item: GroceryItem) async throws {
        store.append(item)
    }

    func updateItem(_ item: GroceryItem) async throws {
        guard let index = store.firstIndex(where: { $0.id == item.id }) else { return }
        store[index] = item
    }

    func deleteItems(ids: [String]) async throws {
        store.removeAll { ids.contains($0.id) }
    }

    func setDefaultItemsIfNeeded(_ items: [GroceryItem]) async throws {
        store.append(contentsOf: items)
    }
}
