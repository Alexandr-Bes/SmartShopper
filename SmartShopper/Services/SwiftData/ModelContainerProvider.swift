//
//  ModelContainerProvider.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 09.05.2025.
//

import Foundation
import SwiftData

@MainActor
final class ModelContainerProvider {
    static let shared = ModelContainerProvider()

    private let container: ModelContainer

    var context: ModelContext {
        container.mainContext
    }

    private init() {
        let schema = Schema([SwiftDataGroceryItem.self, SwiftDataGroceryStore.self], version: .init(1, 0, 0))
        // Add cloudKit when needed
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false, cloudKitDatabase: .none)

        do {
            self.container = try ModelContainer(for: SwiftDataGroceryItem.self, SwiftDataGroceryStore.self,
                                                configurations: config)
        } catch {
            Log.debug(error) //TODO: - Handle error
            fatalError("Can't initialize ModelContainer")
        }
    }
}
