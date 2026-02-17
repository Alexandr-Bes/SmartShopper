//
//  GroceryItem.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 05.05.2025.
//

import Foundation

struct GroceryItem: Identifiable, Sendable, Equatable {
    let id: String
    let name: String
    let category: GroceryItemCategory
    let stores: [GroceryStore]
    var isBought: Bool
    var sortIndex: Int?
    var isDeleted: Bool
    let createdAt: Date
    var updatedAt: Date
    var lastTimeBought: Date?

    init(
        id: String = UUID().uuidString,
        name: String,
        category: GroceryItemCategory,
        stores: [GroceryStore],
        isBought: Bool = false,
        sortIndex: Int? = nil,
        isDeleted: Bool = false,
        createdAt: Date = Date.now,
        updatedAt: Date = Date.now,
        lastTimeBought: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.stores = stores
        self.isBought = isBought
        self.sortIndex = sortIndex
        self.isDeleted = isDeleted
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.lastTimeBought = lastTimeBought
    }

    var emoji: String? {
        EmojiProvider.emoji(for: name)
    }

    static func == (lhs: GroceryItem, rhs: GroceryItem) -> Bool {
        lhs.id == rhs.id
    }
}

struct GroceryStore: Identifiable, Equatable, Comparable, Hashable {
    let id: String
    let name: String
    let location: String? // TODO: - longitude/latitude ?
    let icon: String?
    let selected: Bool

    init(id: String = UUID().uuidString, name: String,
         location: String? = nil, icon: String? = nil,
         selected: Bool = false) {
        self.id = id
        self.name = name
        self.location = location
        self.icon = icon
        self.selected = selected
    }

    static func == (lhs: GroceryStore, rhs: GroceryStore) -> Bool {
//        lhs.id == rhs.id
        lhs.name == rhs.name
    }

    static func < (lhs: GroceryStore, rhs: GroceryStore) -> Bool {
        lhs.name < rhs.name
    }
}

enum GroceryItemCategory: String, CaseIterable, Comparable {
    case fruits
    case vegetables
    case meat
    case fish
    case spices
    case cerealAndPasta
    case seasoning
    case sweat
    case drinks
    case unCategorized

    var sortOrder: Int {
        switch self {
        case .fruits: return 0
        case .vegetables: return 1
        case .meat: return 2
        case .fish: return 3
        case .spices: return 4
        case .cerealAndPasta: return 5
        case .seasoning: return 6
        case .sweat: return 7
        case .drinks: return 8
        case .unCategorized: return 99
        }
    }

    static func < (lhs: GroceryItemCategory, rhs: GroceryItemCategory) -> Bool {
        lhs.sortOrder < rhs.sortOrder
    }

    init?(flexibleRaw value: String) {
        let normalized = value.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        self.init(rawValue: normalized)
    }
}

enum GroceryItemsSortType: CaseIterable {
    case name
    case category

    var title: String {
        switch self {
        case .name: return "Name"
        case .category: return "Category"
        }
    }
}
