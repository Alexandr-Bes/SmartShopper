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

    @MainActor
    func fetchItems() async throws -> [any GroceryItemStorable] { // async?
        let descriptor = FetchDescriptor<SwiftDataGroceryItem>()
        let result = try context.fetch(descriptor)
        return result
    }

    func updateItems(_ items: [any GroceryItemProtocol]) async throws {
        try context.save()
    }

    func deleteItems(with ids: [String]) async throws {
//        for id in ids {
//            let descriptor = FetchDescriptor<SwiftDataGroceryItem>(
//                predicate: #Predicate { $0.id == id }
//            )
//            if let item = try context.fetch(descriptor).first {
//                context.delete(item)
//            }
//        }
//        try context.save()
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
