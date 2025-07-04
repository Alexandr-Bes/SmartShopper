//
//  SwiftDataGroceryDataSource.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 09.05.2025.
//
import Foundation
import SwiftData

@MainActor
final class SwiftDataGroceryDataSource: GroceryDataSourceProtocol {

    private let context: ModelContext
    private let localStorage: LocalStorageAdapter

    private var didSeedDefaults: Bool {
        localStorage.get(for: UserDefaultsKey.didSetDefaultItems, default: false)
    }

    init(modelContext: ModelContext, localStorage: LocalStorageAdapter) {
        self.context = modelContext
        self.localStorage = localStorage
    }

    func fetchItems() async throws -> [SwiftDataGroceryItem] {
        let descriptor = FetchDescriptor<SwiftDataGroceryItem>()
        let result = try context.fetch(descriptor)
        return result
    }

    func fetchItems() async throws -> [any GroceryItemStorable] {
        let descriptor = FetchDescriptor<SwiftDataGroceryItem>()
        let result = try context.fetch(descriptor)
        return result
    }

    func updateItem(_ item: any GroceryItemProtocol) async throws {
        let itemId = item.id
        let descriptor = FetchDescriptor<SwiftDataGroceryItem>(
            predicate: #Predicate { $0.id == itemId }
        )
        guard let storedItem = try context.fetch(descriptor).first else {
            Log.error("Can't find item: \(item)")
            return
        }

        //TODO: updating other values as well
        storedItem.isBought = item.isBought
//        storedItem.category = item.category
//        storedItem.sortIndex = item.sortIndex
//        storedItem.stores = item.stores
//        storedItem.updatedAt = Date()
        do {
            try context.save()
        } catch {
            Log.error("Can't update item: \(item). Error: \(error)")
        }
    }

    func updateItems(_ items: [any GroceryItemProtocol]) async throws {
        do {
            try context.save()
        } catch {
            Log.debug(error)
        }
    }

    func deleteItems(with ids: [String]) async throws {
        for id in ids {
            let descriptor = FetchDescriptor<SwiftDataGroceryItem>(
                predicate: #Predicate { $0.id == id }
            )
            if let item = try context.fetch(descriptor).first {
                context.delete(item)
            }
        }
        try context.save()
    }
    
    func setDefaultItemsIfNeeded(_ items: [any GroceryItemProtocol]) async throws {
        guard !didSeedDefaults else { return }
        for item in items {
            let entity = SwiftDataGroceryItem(from: item)
            context.insert(entity)
        }
        try context.save()
        localStorage.set(true, for: UserDefaultsKey.didSetDefaultItems)
    }
}
