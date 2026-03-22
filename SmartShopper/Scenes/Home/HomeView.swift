//
//  HomeView.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 05.05.2025.
//

import SwiftUI

struct HomeView: View {
    @State var viewModel: HomeViewModel
    let manageViewModel: ManageItemsViewModel

    @State private var isShowingAddSheet = false
    @State private var showPremiumInfo = false

    var body: some View {
        List {
            ForEach(viewModel.sections) { categoryGroup in
                Section(header: Text(categoryGroup.category.title)) {
                    ForEach(categoryGroup.items, id: \.id) { item in
                        GroceryItemRow(item: item) {
                            viewModel.toggleItem(item)
                        }
                    }
                    .onDelete { indexSet in
                        let ids = indexSet.map { categoryGroup.items[$0].id }
                        Task {
                            await viewModel.deleteItems(ids: ids)
                        }
                    }
                }
            }
        }
        .navigationTitle(Localization.text(.homeTitle))
        .navigationDestination(for: String.self) { itemID in
            ItemDetailsView(viewModel: manageViewModel, itemID: itemID)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                storePickerView
            }
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    addNewItemAction()
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityLabel(Localization.text(.addItem))

                sortItemsView
            }
        }
        .sheet(isPresented: $isShowingAddSheet) {
            ItemEditorSheet(
                mode: .add,
                stores: manageViewModel.stores,
                selectedStore: manageViewModel.suggestedStoreForNewItem,
                canUseExpiration: manageViewModel.canUseExpiration,
                onPremiumActionTap: { showPremiumInfo = true },
                initialExpirationDays: nil
            ) { draft in
                await manageViewModel.addItem(
                    name: draft.name,
                    category: draft.category,
                    stores: draft.stores,
                    expirationDays: draft.expirationDays
                )
            }
        }
        .alert(Localization.text(.premiumLocked), isPresented: $showPremiumInfo) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(Localization.text(.premiumFeature))
        }
//        .animation(.snappy, value: viewModel.sections)
    }

    private func addNewItemAction() {
        manageViewModel.loadSuggestedStore()
        isShowingAddSheet = true
    }

    @ViewBuilder
    var storePickerView: some View {
        Menu {
            Button {
                viewModel.showAllStores()
            } label: {
                if viewModel.isShowingAllStores {
                    Label(Localization.text(.allStores), systemImage: "checkmark")
                } else {
                    Text(Localization.text(.allStores))
                }
            }

            ForEach(viewModel.stores, id: \.id) { store in
                Button {
                    viewModel.selectedStore = store
                    viewModel.filterByStore()
                } label: {
                    if !viewModel.isShowingAllStores && viewModel.selectedStore == store {
                        Label(store.name, systemImage: "checkmark")
                    } else {
                        Text(store.name)
                    }
                }
            }
        } label: {
            Image(systemName: "storefront")
                .foregroundStyle(.yellow)
        }
    }

    @ViewBuilder
    var sortItemsView: some View {
        Menu {
            ForEach(GroceryItemsSortType.allCases, id: \.self) { choice in
                Button {
                    viewModel.sortOption = choice
                    viewModel.sortItems()
                } label: {
                    if viewModel.sortOption == choice {
                        Label(choice.title, systemImage: "checkmark")
                    } else {
                        Text(choice.title)
                    }
                }
            }
        } label: {
            Image(systemName: "ellipsis")
        }
    }
}

#Preview {
    let shared = SharedViewModel(items: mockItems)
    NavigationStack {
        HomeView(
            viewModel: HomeViewModel(shared: shared),
            manageViewModel: ManageItemsViewModel(
                shared: shared,
                premiumAccess: BasicPremiumAccess(),
                locationService: LocationService()
            )
        )
    }
}
