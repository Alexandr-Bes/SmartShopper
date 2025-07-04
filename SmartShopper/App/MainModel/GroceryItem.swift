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
    var isBought: Bool = false
    var sortIndex: Int?

    init(id: String = UUID().uuidString,
         name: String,
         category: GroceryItemCategory,
         stores: [GroceryStore],
         isBought: Bool = false,
         sortIndex: Int? = nil) {
        self.id = id
        self.name = name
        self.category = category
        self.stores = stores
        self.isBought = isBought
        self.sortIndex = sortIndex
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

    init(id: String = UUID().uuidString, name: String, location: String? = nil, icon: String? = nil) {
        self.id = id
        self.name = name
        self.location = location
        self.icon = icon
    }

    static func == (lhs: GroceryStore, rhs: GroceryStore) -> Bool {
        lhs.id == rhs.id
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

enum GroceryItemsSortType {
    case name
    case category
}
