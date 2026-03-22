//
//  HomeView.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 14.05.2025.
//


import Observation
import Foundation

@MainActor
@Observable
final class HomeViewModel {
    private var sharedViewModel: GroceryItemStoreProtocol

    init(shared: GroceryItemStoreProtocol) {
        self.sharedViewModel = shared
    }

    var sections: [GroceryItemSection] {
        sharedViewModel.sections
    }

    var stores: [GroceryStore] {
        get { sharedViewModel.stores }
        set { sharedViewModel.stores = newValue }
    }

    var selectedStore: GroceryStore {
        get { sharedViewModel.selectedStore }
        set { sharedViewModel.selectedStore = newValue }
    }

    var sortOption: GroceryItemsSortType {
        get { sharedViewModel.sortOption }
        set { sharedViewModel.sortOption = newValue }
    }

    var isShowingAllStores: Bool {
        !sharedViewModel.showsSelectedStoreOnly
    }

    func toggleItem(_ item: GroceryItem) {
        sharedViewModel.toggleItem(item)
    }

    func filterByStore() {
        sharedViewModel.filterByStore()
    }

    func showAllStores() {
        sharedViewModel.showAllStores()
    }

    func sortItems() {
        sharedViewModel.sortItems()
    }

    func item(withID id: String) -> GroceryItem? {
        sharedViewModel.item(withID: id)
    }

    func deleteItems(ids: [String]) async {
        await sharedViewModel.deleteItems(ids: ids)
    }
}
