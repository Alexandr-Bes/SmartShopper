//
//  AppManager.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 05.05.2025.
//

import Observation
import SwiftData

@MainActor
@Observable
final class AppManager {
    private var actualStore = GroceryStore(name: "Pingo Doce")

    let context: ModelContext

    let dataSource: GroceryDataSourceProtocol
    let groceryRepository: GroceryRepositoryProtocol
    let premiumAccess: PremiumAccessProviding
    let locationService: LocationServiceProtocol

    var currentStore: GroceryStore { actualStore }
    var deepLinkTarget: TabTarget?
    var deepLinkRoute: DeepLinkRoute?

    init(context: ModelContext,
         dataSource: GroceryDataSourceProtocol,
         premiumAccess: PremiumAccessProviding = BasicPremiumAccess(),
         locationService: LocationServiceProtocol = LocationService()) {
        self.context = context
        self.dataSource = dataSource
        self.groceryRepository = GroceryRepository(dataSource: dataSource)
        self.premiumAccess = premiumAccess
        self.locationService = locationService
    }

    func appLaunched() async {
        // TODO: - Get data from location or last selected
        actualStore = mockStores.first!
        await setupStorage()
    }
}

private extension AppManager {
    func setupStorage() async {
        await setDefaultItemsIfNeeded(using: dataSource)
    }

    func setDefaultItemsIfNeeded(using dataSource: GroceryDataSourceProtocol) async {
        let defaultItems = groceryDefaultItems
        try? await dataSource.setDefaultItemsIfNeeded(defaultItems)
    }
}

@MainActor
enum AppManagerFactory {
    static func make() async -> AppManager {
        let context = ModelContainerProvider.shared.context
        let dataSource = SwiftDataGroceryDataSource(modelContext: context, localStorage: UserDefaultsStorageAdapter())
        return AppManager(context: context, dataSource: dataSource)
    }

    static func makeTesting() -> AppManager {
        let preview = PreviewModelContainer()
        preview.addExamples()
        let context = preview.context
        let dataSource = PreviewMockedDataSource(initial: mockItems)
        return AppManager(context: context, dataSource: dataSource)
    }
}
