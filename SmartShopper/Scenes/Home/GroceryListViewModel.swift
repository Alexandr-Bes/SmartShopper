//
//  GroceryListViewModel.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 05.05.2025.
//

import SwiftUI
import Combine

protocol GroceryListViewModelProtocol: Observable {
    var items: [GroceryItem] { get set }
    var categorizedItems: [(category: GroceryItemCategory, items: [GroceryItem])] { get }
    var selectedStore: GroceryStore { get set }
    var stores: [GroceryStore] { get set }
    var sortOption: GroceryItemsSortType { get set }

    func loadItems()
    func toggleItem(_ item: GroceryItem)
    func addItem(name: String, category: GroceryItemCategory, stores: [GroceryStore]) async -> Bool
    func updateItem(
        id: String,
        name: String,
        category: GroceryItemCategory,
        stores: [GroceryStore],
        isBought: Bool
    ) async -> Bool
    func deleteItems(ids: [String]) async
    func item(withID id: String) -> GroceryItem?
    func sortItems()
    func filterByStore()
}

@Observable
final class GroceryListViewModel: GroceryListViewModelProtocol {

    var items: [GroceryItem] = []

    var categorizedItems: [(category: GroceryItemCategory, items: [GroceryItem])] {
        let filteredItems = isStoreFilterEnabled
            ? items.filter { $0.stores.contains(selectedStore) }
            : items

        switch sortOption {
        case .category:
            let grouped = Dictionary(grouping: filteredItems) { $0.category }
            return grouped
                .map { (category: $0.key, items: $0.value.sorted { $0.name < $1.name }) }
                .sorted { $0.category < $1.category }
        case .name:
            return [(category: .unCategorized, items: filteredItems.sorted { $0.name < $1.name })]
        }

    }

    var selectedStore: GroceryStore
    var sortOption: GroceryItemsSortType = .category
    var stores: [GroceryStore] = mockStores // Pass to View

    private let repository: any GroceryRepositoryProtocol
    private var isStoreFilterEnabled: Bool = false // Enables after user's action

    init(repository: any GroceryRepositoryProtocol) {
        self.repository = repository
        self.selectedStore = repository.getSelectedStore()
        loadItems()
    }

    // For Previews
    init(items: [GroceryItem]) {
        self.items = items
        self.repository = MockGroceryRepository()
        self.selectedStore = mockStores.first!
    }

    func loadItems() {
        Task {
            do {
                let items = try await repository.getItems()
                self.items = items
            } catch {
                Log.error("Failed to load items: \(error)")
            }
        }
    }

    func toggleItem(_ item: GroceryItem) {
        guard let index = items.firstIndex(of: item) else { return }
        var updatedItem = item
        updatedItem.isBought.toggle()
        items[index] = updatedItem

        Task {
            await update(item: updatedItem)
            Log.debug("Updated item: \(updatedItem)")
        }
    }

    func sortItems() {
        switch sortOption {
        case .name:
            items.sort { $0.name < $1.name }
        case .category:
            items.sort {
                if $0.category == $1.category {
                    return $0.name < $1.name
                }
                return $0.category < $1.category
            }
        }
    }

    func addItem(name: String, category: GroceryItemCategory, stores: [GroceryStore]) async -> Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return false }

        let resolvedStores = stores.isEmpty ? [selectedStore] : stores.sorted()
        let newItem = GroceryItem(
            name: trimmedName,
            category: category,
            stores: resolvedStores,
            isBought: false
        )

        items.append(newItem)
        sortItems()

        do {
            try await repository.add(newItem)
            return true
        } catch {
            items.removeAll { $0.id == newItem.id }
            Log.error("Failed to add item: \(error)")
            return false
        }
    }

    func updateItem(
        id: String,
        name: String,
        category: GroceryItemCategory,
        stores: [GroceryStore],
        isBought: Bool
    ) async -> Bool {
        guard let index = items.firstIndex(where: { $0.id == id }) else { return false }

        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return false }

        let previous = items[index]
        let resolvedStores = stores.isEmpty ? [selectedStore] : stores.sorted()
        let updated = GroceryItem(
            id: previous.id,
            name: trimmedName,
            category: category,
            stores: resolvedStores,
            isBought: isBought,
            sortIndex: previous.sortIndex,
            isDeleted: previous.isDeleted,
            createdAt: previous.createdAt,
            updatedAt: .now
        )

        items[index] = updated
        sortItems()

        do {
            try await repository.updateItem(updated)
            return true
        } catch {
            items[index] = previous
            Log.error("Failed to edit item: \(error)")
            return false
        }
    }

    func deleteItems(ids: [String]) async {
        let previous = items
        items.removeAll { ids.contains($0.id) }

        do {
            try await repository.deleteItems(ids)
        } catch {
            items = previous
            Log.error("Failed to delete items: \(error)")
        }
    }

    func item(withID id: String) -> GroceryItem? {
        items.first(where: { $0.id == id })
    }

    func filterByStore() {
        isStoreFilterEnabled = true
    }
}

private extension GroceryListViewModel {
    func update(item: GroceryItem) async {
        do {
            try await repository.updateItem(item)
        } catch {
            Log.error("Failed to update items: \(error)")
        }
    }
}
