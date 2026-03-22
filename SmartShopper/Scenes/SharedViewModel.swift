//
//  SharedViewModel.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 05.05.2025.
//

import SwiftUI
import Combine

protocol GroceryItemStoreProtocol: Observable {
    var items: [GroceryItem] { get set }
    var sections: [GroceryItemSection] { get }
    var selectedStore: GroceryStore { get set }
    var stores: [GroceryStore] { get set }
    var sortOption: GroceryItemsSortType { get set }
    var showsSelectedStoreOnly: Bool { get }

    func loadItems()
    func toggleItem(_ item: GroceryItem)
    func addItem(
        name: String,
        category: GroceryItemCategory,
        stores: [GroceryStore],
        expirationDate: Date?
    ) async -> Bool
    func updateItem(
        id: String,
        name: String,
        category: GroceryItemCategory,
        stores: [GroceryStore],
        isBought: Bool,
        expirationDate: Date?
    ) async -> Bool
    func deleteItems(ids: [String]) async
    func item(withID id: String) -> GroceryItem?
    func searchItems(query: String) -> [GroceryItem]
    func sortItems()
    func filterByStore()
    func showAllStores()
}

@Observable
final class SharedViewModel: GroceryItemStoreProtocol {

    //MARK: - Properties
    var items: [GroceryItem] = []

    var sections: [GroceryItemSection] {
        makeSections(from: visibleItems)
    }

    var stores: [GroceryStore] = mockStores
    var selectedStore: GroceryStore

    var sortOption: GroceryItemsSortType = .category

    private let repository: any GroceryRepositoryProtocol
    var showsSelectedStoreOnly: Bool = false

    //MARK: - Init
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

    //MARK: - Public Methods
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
        guard let index = indexOfItem(withID: item.id) else { return }
        var updatedItem = items[index]
        updatedItem.isBought.toggle()
        if updatedItem.isBought {
            updatedItem.lastTimeBought = .now
        }
        updatedItem.updatedAt = .now
        items[index] = updatedItem

        Task {
            await persistUpdate(item: updatedItem)
        }
    }

    func addItem(
        name: String,
        category: GroceryItemCategory,
        stores: [GroceryStore],
        expirationDate: Date?
    ) async -> Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return false }

        let resolvedStores = stores.isEmpty ? [selectedStore] : stores.sorted()
        let newItem = GroceryItem(
            name: trimmedName,
            category: category,
            stores: resolvedStores,
            isBought: false,
            expirationDate: expirationDate
        )

        items.append(newItem)

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
        isBought: Bool,
        expirationDate: Date?
    ) async -> Bool {
        guard let index = indexOfItem(withID: id) else { return false }

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
            expirationDate: expirationDate,
            sortIndex: previous.sortIndex,
            isDeleted: previous.isDeleted,
            createdAt: previous.createdAt,
            updatedAt: .now,
            lastTimeBought: isBought ? (previous.lastTimeBought ?? .now) : previous.lastTimeBought
        )

        items[index] = updated

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
        let idsSet = Set(ids)
        items.removeAll { idsSet.contains($0.id) }

        do {
            try await repository.deleteItems(ids)
        } catch {
            items = previous
            Log.error("Failed to delete items: \(error)")
        }
    }

    func item(withID id: String) -> GroceryItem? {
        guard let index = indexOfItem(withID: id) else { return nil }
        return items[index]
    }

    func searchItems(query: String) -> [GroceryItem] {
        let normalized = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !normalized.isEmpty else { return [] }

        return items
            .filter { $0.name.lowercased().contains(normalized) }
            .sorted { lhs, rhs in
                if lhs.name == rhs.name {
                    return lhs.category < rhs.category
                }
                return lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
            }
    }

    func sortItems() {
        switch sortOption {
        case .name:
            items.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .category:
            items.sort {
                if $0.category == $1.category {
                    return $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
                }
                return $0.category < $1.category
            }
        }
    }

    func filterByStore() {
        showsSelectedStoreOnly = true
    }

    func showAllStores() {
        showsSelectedStoreOnly = false
    }
}

//MARK: - Private
private extension SharedViewModel {
    var visibleItems: [GroceryItem] {
        guard showsSelectedStoreOnly else { return items }
        return items.filter { $0.stores.contains(selectedStore) }
    }

    func indexOfItem(withID id: String) -> Int? {
        items.firstIndex { $0.id == id }
    }

    func makeSections(from items: [GroceryItem]) -> [GroceryItemSection] {
        let sorted: [GroceryItem]
        switch sortOption {
        case .name:
            sorted = items.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
            return [GroceryItemSection(category: .unCategorized, items: sorted)]
        case .category:
            sorted = items.sorted {
                if $0.category == $1.category {
                    return $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
                }
                return $0.category < $1.category
            }

            let grouped = Dictionary(grouping: sorted, by: \.category)
            return grouped
                .map { GroceryItemSection(category: $0.key, items: $0.value) }
                .sorted { $0.category < $1.category }
        }
    }

    func persistUpdate(item: GroceryItem) async {
        do {
            try await repository.updateItem(item)
        } catch {
            Log.error("Failed to update items: \(error)")
        }
    }
}
