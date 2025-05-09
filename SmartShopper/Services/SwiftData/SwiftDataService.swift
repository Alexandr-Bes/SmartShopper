//
//  SwiftDataService.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 07.05.2025.
//

import Foundation
import SwiftData

protocol DataServiceProtocol {
//    func getItems<T>
}

actor SwiftDataService: DataServiceProtocol {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

//    func getItems(for store: GroceryStore) async throws -> [GroceryItem] {
//        let descriptor = FetchDescriptor<GroceryItem>(
//            predicate: #Predicate { $0.store == store }
//        )
//        return try context.fetch(descriptor)
//    }
}
