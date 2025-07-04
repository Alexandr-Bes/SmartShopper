//
//  GroceryDataSourceProtocol.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 09.05.2025.
//

import Foundation

protocol GroceryDataSourceProtocol: Sendable {
    func fetchItems() async throws -> [GroceryItem]
    func updateItem(_ item: GroceryItem) async throws
    func deleteItems(ids: [String]) async throws
    func setDefaultItemsIfNeeded(_ items: [GroceryItem]) async throws
}
