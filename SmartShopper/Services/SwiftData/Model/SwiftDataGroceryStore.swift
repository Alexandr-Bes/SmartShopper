//
//  SwiftDataGroceryStore.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 07.05.2025.
//

import Foundation
import SwiftData

@Model
final class SwiftDataGroceryStore: Hashable, Equatable {
    @Attribute(.unique) var id: String
    var name: String
    var location: String?
    var icon: String?
    var createdAt: Date?
    var updatedAt: Date?

    @Relationship(deleteRule: .nullify, inverse: \SwiftDataGroceryItem.stores)
    var items: [SwiftDataGroceryItem]

    init(id: String = UUID().uuidString,
         name: String,
         location: String? = nil,
         icon: String? = nil,
         createdAt: Date = Date(),
         updatedAt: Date? = nil,
         items: [SwiftDataGroceryItem] = []) {
        self.id = id
        self.name = name
        self.location = location
        self.icon = icon
        self.items = items
    }

    static func == (lhs: SwiftDataGroceryStore, rhs: SwiftDataGroceryStore) -> Bool {
        lhs.id == rhs.id
    }
}

extension SwiftDataGroceryStore: GroceryStoreStorable { }
