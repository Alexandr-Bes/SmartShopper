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

    private var didSeedDefaults: Bool {
        UserDefaults.standard.bool(forKey: "didSeedGroceryItems") // TODO: - Move to wrapper
    }

    init(modelContext: ModelContext) {
        self.context = modelContext
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
        UserDefaults.standard.set(true, forKey: "didSetGroceryItems")
    }
}
