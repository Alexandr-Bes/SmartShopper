import Foundation
import Observation

@Observable
final class ManageItemsViewModel {
    let sharedViewModel: SharedViewModel
    private let premiumAccess: PremiumAccessProviding
    private let locationService: LocationServiceProtocol

    var suggestedStoreForNewItem: GroceryStore?
    var lastAddedItemID: String?

    init(
        shared: SharedViewModel,
        premiumAccess: PremiumAccessProviding,
        locationService: LocationServiceProtocol
    ) {
        self.sharedViewModel = shared
        self.premiumAccess = premiumAccess
        self.locationService = locationService
    }

    var sections: [GroceryItemSection] {
        sharedViewModel.sections
    }

    var items: [GroceryItem] {
        sharedViewModel.items
    }

    var stores: [GroceryStore] {
        sharedViewModel.stores.sorted()
    }

    var selectedStore: GroceryStore {
        sharedViewModel.selectedStore
    }

    var canUseExpiration: Bool {
        premiumAccess.isEnabled(.expirationTracking)
    }

    var canUseNearbyStorePreselection: Bool {
        premiumAccess.isEnabled(.nearbyStorePreselection)
    }

    func loadSuggestedStore() {
        guard canUseNearbyStorePreselection else {
            suggestedStoreForNewItem = selectedStore
            return
        }

        locationService.requestPermissionIfNeeded()
        locationService.start()
        suggestedStoreForNewItem = locationService.nearestStore(from: sharedViewModel.stores) ?? selectedStore
    }

    func addItem(
        name: String,
        category: GroceryItemCategory,
        stores: [GroceryStore],
        expirationDays: Int?
    ) async -> Bool {
        let expirationDate = expirationDays.map { Calendar.current.date(byAdding: .day, value: $0, to: .now) ?? .now }
        let didAdd = await sharedViewModel.addItem(name: name, category: category, stores: stores, expirationDate: expirationDate)

        if didAdd {
            lastAddedItemID = sharedViewModel.items.last?.id
        }

        return didAdd
    }

    func updateItem(
        id: String,
        name: String,
        category: GroceryItemCategory,
        stores: [GroceryStore],
        isBought: Bool,
        expirationDays: Int?
    ) async -> Bool {
        let expirationDate = expirationDays.map { Calendar.current.date(byAdding: .day, value: $0, to: .now) ?? .now }
        return await sharedViewModel.updateItem(
            id: id,
            name: name,
            category: category,
            stores: stores,
            isBought: isBought,
            expirationDate: expirationDate
        )
    }

    func expirationDays(from item: GroceryItem) -> Int? {
        guard let expirationDate = item.expirationDate else { return nil }
        let components = Calendar.current.dateComponents([.day], from: .now, to: expirationDate)
        guard let day = components.day else { return nil }
        return max(0, day)
    }

    func deleteItems(ids: [String]) async {
        await sharedViewModel.deleteItems(ids: ids)
    }

    func item(withID id: String) -> GroceryItem? {
        sharedViewModel.item(withID: id)
    }
}
