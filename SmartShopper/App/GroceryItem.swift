//
//  GroceryItem.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 05.05.2025.
//

import Foundation

protocol GroceryItemProtocol {
    var id: String { get }
    var name: String { get }
    var category: GroceryItemCategory { get }
    var store: GroceryStore { get }
    var isBought: Bool { get set }
    var sortIndex: Int? { get set }
    var emoji: String? { get }
}

struct GroceryItem: GroceryItemProtocol, Identifiable, Equatable {

    let id: String = UUID().uuidString
    let name: String
    let category: GroceryItemCategory
    let store: GroceryStore
    var isBought: Bool = false
    var sortIndex: Int?

    var emoji: String? {
        EmojiProvider.emoji(for: name)
    }
}

enum GroceryStore: CaseIterable, Comparable {
    case pingoDoce
    case continente

    var name: String {
        switch self {
        case .pingoDoce: "Pingo Doce"
        case .continente: "Continente"
        }
    }
}

enum GroceryItemCategory: CaseIterable, Comparable {
    case fruits
    case vegetables
    case meat
    case fish
    case spices
    case cerealAndNoodles
    case unCategorized
}

enum GroceryItemsSortType {
    case name
    case category
    case store
}
