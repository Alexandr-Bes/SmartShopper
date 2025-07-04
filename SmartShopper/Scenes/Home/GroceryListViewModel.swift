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
    var selectedStore: GroceryStore { get set }
    var sortOption: GroceryItemsSortType { get set }

    func loadItems() async
    func toggleItem(_ item: GroceryItem)
    func addItem(_ item: GroceryItem)
    func sortItems()
}

@Observable
final class GroceryListViewModel: GroceryListViewModelProtocol {

    var items: [GroceryItem] = []
    var selectedStore = GroceryStore(name: "")
    var sortOption: GroceryItemsSortType = .category
    var stores: [GroceryStore] = mockStores

    private let repository: any GroceryRepositoryProtocol

    init(currentStore: GroceryStore, repository: any GroceryRepositoryProtocol) {
        self.selectedStore = currentStore
        self.repository = repository
        loadItems()
    }

    // For Previews
    init(items: [GroceryItem]) {
        self.items = items
        self.repository = MockGroceryRepository()
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
            items.sort { $0.category < $1.category }
        }
    }

    func addItem(_ item: GroceryItem) {
        items.append(item)
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
