//
//  MockGroceryRepository.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 04.07.2025.
//

import Foundation

final class MockGroceryRepository: GroceryRepositoryProtocol {
    func getItems() async throws -> [GroceryItem] {
        mockItems
    }
    
    func updateItem(_ item: any GroceryItemProtocol) async throws {
        Log.debug("Update item: \(item)")
    }
    
    func updateItems(_ items: [GroceryItem]) async throws {
        Log.debug("Update items: \(items)")
    }
    
    func deleteItems(_ ids: [String]) {
        Log.debug("Delete items ids: \(ids)")
    }
}
