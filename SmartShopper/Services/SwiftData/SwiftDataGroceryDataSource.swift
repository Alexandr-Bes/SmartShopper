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

    func fetchItems() async throws -> [GroceryItem] {
        let descriptor = FetchDescriptor<SwiftDataGroceryItem>()
        let result = try context.fetch(descriptor)
        return result.map { $0.toDomainModel() }
    }

    func addItem(_ item: GroceryItem) async throws {
        let entity = SwiftDataGroceryItem(from: item)
        context.insert(entity)
        try context.save()
    }

    func updateItem(_ item: GroceryItem) async throws {
        let itemId = item.id
        let descriptor = FetchDescriptor<SwiftDataGroceryItem>(
            predicate: #Predicate { $0.id == itemId }
        )
        guard let model = try context.fetch(descriptor).first else {
            Log.error("Can't find item: \(item)")
            return
        }

        model.name = item.name
        model.isBought = item.isBought
        model.expirationDate = item.expirationDate
        model.category = item.category.rawValue
        model.sortIndex = item.sortIndex
        model.updatedAt = item.updatedAt

        try context.save()
    }

    func deleteItems(ids: [String]) async throws {
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
    
    func setDefaultItemsIfNeeded(_ items: [GroceryItem]) async throws {
        guard !didSeedDefaults else { return }
        for item in items {
            let entity = SwiftDataGroceryItem(from: item)
            context.insert(entity)
        }
        try context.save()
        localStorage.set(true, for: UserDefaultsKey.didSetDefaultItems)
    }
}
