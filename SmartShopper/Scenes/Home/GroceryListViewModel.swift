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

    func loadItems() async
    func toggleItem(_ item: GroceryItem)
    func addItem(with name: String)
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

    func addItem(with name: String) {
        let newItem = GroceryItem(
            name: name,
            category: .unCategorized,
            stores: [mockStores.first!], // TODO: - Store
            isBought: false
        )
        items.append(newItem)
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
