//
//  SwiftDataGroceryItem.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 07.05.2025.
//

import Foundation
import SwiftData

@Model
final class SwiftDataGroceryItem {
    @Attribute(.unique) var id: String
    var name: String
    var category: String
    var isBought: Bool
    var sortIndex: Int?
    var createdAt: Date?
    var updatedAt: Date?

    var stores: [SwiftDataGroceryStore]

    init(id: String = UUID().uuidString,
         name: String,
         category: String,
         isBought: Bool = false,
         sortIndex: Int? = nil,
         stores: [SwiftDataGroceryStore] = []) {
        self.id = id
        self.name = name
        self.category = category
        self.isBought = isBought
        self.sortIndex = sortIndex
        self.stores = stores
    }
}

// MARK: - Grocery Item Storable
extension SwiftDataGroceryItem: GroceryItemStorable {
    typealias StoreType = SwiftDataGroceryStore
    var icon: String? { nil } // For now
    var categoryRaw: String { category }
}

// MARK: - Init from Grocery Item
extension SwiftDataGroceryItem {
    convenience init(from item: GroceryItemProtocol) {
        self.init(
            id: item.id,
            name: item.name,
            category: item.category.rawValue,
            isBought: item.isBought,
            sortIndex: item.sortIndex,
            stores: item.stores.map { StoreType(id: $0.id, name: $0.name, location: $0.location, icon: $0.icon) }
        )
    }
}
