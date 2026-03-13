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
    var expirationDate: Date?
    var sortIndex: Int?
    var createdAt: Date?
    var updatedAt: Date?

    var stores: [SwiftDataGroceryStore]

    init(from item: GroceryItem) {
        self.id = item.id
        self.name = item.name
        self.category = item.category.rawValue //TODO: - Check if this works properly (same string lowercased, etc.)
        self.isBought = item.isBought
        self.expirationDate = item.expirationDate
        self.sortIndex = item.sortIndex
        self.createdAt = item.createdAt
        self.updatedAt = item.updatedAt
        #warning("Grocery stores doesn't get stored")
        self.stores = [] //item.stores //TODO: - Add mapper
    }

    init(id: String = UUID().uuidString,
         name: String,
         category: String,
         isBought: Bool = false,
         expirationDate: Date? = nil,
         sortIndex: Int? = nil,
         createdAt: Date = Date(),
         updatedAt: Date? = nil,
         stores: [SwiftDataGroceryStore] = []) {
        self.id = id
        self.name = name
        self.category = category
        self.isBought = isBought
        self.expirationDate = expirationDate
        self.sortIndex = sortIndex
        self.stores = stores
    }

    func toDomainModel() -> GroceryItem {
        GroceryItem(id: id,
                    name: name,
                    category: GroceryItemCategory(rawValue: category) ?? .unCategorized,
                    stores: stores.map { GroceryStore(id: $0.id, name: $0.name) },
                    isBought: isBought,
                    expirationDate: expirationDate,
                    sortIndex: sortIndex,
                    createdAt: createdAt ?? .now,
                    updatedAt: updatedAt ?? .now)
    }
}
