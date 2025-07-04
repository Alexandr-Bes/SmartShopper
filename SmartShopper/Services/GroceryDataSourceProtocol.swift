//
//  GroceryDataSourceProtocol.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 09.05.2025.
//

import Foundation

protocol GroceryDataSourceProtocol {
    func fetchItems() async throws -> [any GroceryItemStorable]
    func updateItem(_ item: any GroceryItemProtocol) async throws
    func updateItems(_ items: [any GroceryItemProtocol]) async throws
    func deleteItems(with ids: [String]) async throws
    func setDefaultItemsIfNeeded(_ items: [any GroceryItemProtocol]) async throws
}
