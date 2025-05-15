//
//  PreviewMockedData.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 14.05.2025.
//

import Foundation
import SwiftData

final class PreviewMockedDataSource: GroceryDataSourceProtocol {

    private let modelContext: ModelContext

    init(context: ModelContext) {
        self.modelContext = context
    }

    @MainActor
    func fetchItems() throws -> [any GroceryItemStorable] {
        let descriptor = FetchDescriptor<SwiftDataGroceryItem>()
        let result = try modelContext.fetch(descriptor)
        return result
    }

    func updateItems(_ items: [any GroceryItemProtocol]) async throws {
        Log.debug(items.map(\.name))
    }

    func deleteItems(with ids: [String]) async throws {
        Log.debug(ids)
    }
    
    func setDefaultItemsIfNeeded(_ items: [any GroceryItemProtocol]) async throws {
        Log.debug("setDefaultItemsIfNeeded")
    }
}
