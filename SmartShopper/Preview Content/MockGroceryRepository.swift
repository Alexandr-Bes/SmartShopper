//
//  MockGroceryRepository.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 04.07.2025.
//

import Foundation

final class MockGroceryRepository: GroceryRepositoryProtocol {

    func getSelectedStore() -> GroceryStore {
        return GroceryStore(name: "Pingo")
    }

    func getItems() async throws -> [GroceryItem] {
        mockItems
    }

    func updateItem(_ item: GroceryItem) async throws {
        Log.debug("Update item: \(item)")
    }

    func deleteItems(_ ids: [String]) async throws {
        Log.debug("Delete items ids: \(ids)")
    }
}
