//
//  PreviewModelContainer.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 15.05.2025.
//

import Foundation
import SwiftData

@MainActor
final class PreviewModelContainer {

    private let container: ModelContainer

    var context: ModelContext {
        container.mainContext
    }

    init() {
        let schema = Schema([SwiftDataGroceryItem.self, SwiftDataGroceryStore.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true, cloudKitDatabase: .none)
        do {
            self.container = try ModelContainer(for: SwiftDataGroceryItem.self, SwiftDataGroceryStore.self,
                                                configurations: config)
        } catch {
            Log.debug(error)
            fatalError("Couldn't initialize PreviewModelContainer. Error: \(error)")
        }
    }

    func addExamples(_ examples: [GroceryItem] = groceryDefaultItems) {
        Task {
            examples.forEach { example in
                let mock = SwiftDataGroceryItem(from: example)
                context.insert(mock)
            }
        }
    }
}
