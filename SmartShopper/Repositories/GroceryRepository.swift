//
//  GroceryRepository.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 05.05.2025.
//

import Foundation

protocol GroceryRepositoryProtocol {
    func getItems() async throws -> [GroceryItem]
    func updateItems(_ items: [GroceryItem])
    func deleteItems(_ ids: [String])
}

final class GroceryRepository: GroceryRepositoryProtocol {

    func getItems() async throws -> [GroceryItem] {
        Log.debug("Preparing to simulate item load...")

        try await Task.sleep(for: .seconds(1)) // Simulated network delay

        let items = mockItems
        let result = items.sorted { $0.category < $1.category }

        Log.debug("Simulated loading \(items.count) grocery items")

        return result
    }

    func updateItems(_ items: [GroceryItem]) {
        Log.debug("Simulating update of \(items.count) items:")
//        items.forEach { Log.debug("Updating item: \($0.name)") }
    }

    func deleteItems(_ ids: [String]) {
        Log.debug("Simulating deletion of \(ids.count) items:")
        ids.forEach { Log.debug("Deleting item with id: \($0)") }
    }
}


//MARK: - MOCKS

let mockStores: [GroceryStore] = [GroceryStore(name: "Pingo Doce"),
                                  GroceryStore(name: "Continente")]
let mockItems = [
    GroceryItem(name: "Milk", category: .unCategorized, stores: [mockStores.first!]),
    GroceryItem(name: "Bread", category: .unCategorized, stores: mockStores),
    GroceryItem(name: "Apples", category: .fruits, stores: mockStores),
    GroceryItem(name: "Oranges", category: .fruits, stores: mockStores),
    GroceryItem(name: "Eggs", category: .meat, stores: mockStores)
]

enum GroceryStoreType: CaseIterable, Comparable, RawRepresentable {
    case pingoDoce
    case continente

    var name: String {
        switch self {
        case .pingoDoce: "Pingo Doce"
        case .continente: "Continente"
        }
    }

    init?(rawValue: String) {
        switch rawValue.lowercased() {
        case "pingoDoce": self = GroceryStoreType.pingoDoce
        case "continente": self = GroceryStoreType.continente
        default: return nil
        }
    }

    var rawValue: String {
        switch self {
        case .pingoDoce: "pingoDoce"
        case .continente: "continente"
        }
    }
}
