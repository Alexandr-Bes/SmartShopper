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

    private var repository: GroceryRepositoryProtocol?

    init(items: [GroceryItem] = []) {
        self.items = items
    }

    init(appManager: AppManager) {
        self.selectedStore = appManager.currentStore
        self.repository = appManager.groceryRepository
        loadItems()
    }

    func bind(to appManager: AppManager) {
        selectedStore = appManager.currentStore
        repository = appManager.groceryRepository
        loadItems()

        withObservationTracking {
            _ = appManager.currentStore
        } onChange: { [weak self, weak appManager] in
            guard let self, let store = appManager?.currentStore else { return }
            if self.selectedStore != store {
                self.selectedStore = store
                self.loadItems()
            }
        }
    }

    func loadItems() {
        Task {
            do {
                let items = try await repository?.getItems()
                self.items = items ?? []
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
        repository?.updateItems(items)
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
