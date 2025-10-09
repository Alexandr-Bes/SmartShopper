//
//  HomeView.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 05.05.2025.
//

import SwiftUI

struct HomeView<ViewModel: GroceryListViewModelProtocol>: View {
    @State var viewModel: ViewModel

    var body: some View {
        VStack {
            if viewModel.items.isEmpty {
                ProgressView()
            }

            listView
        }
        .navigationTitle("List")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                storePickerView
            }
            ToolbarItem(placement: .topBarTrailing) {
                sortItemsView
            }
        }
    }

    @ViewBuilder var storePickerView: some View {
        Menu {
            ForEach(viewModel.stores, id: \.id) { store in
                Button {
                    viewModel.selectedStore = store
                    viewModel.filterByStore()
                } label: {
                    if viewModel.selectedStore == store {
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

    @ViewBuilder var sortItemsView: some View {
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

    @ViewBuilder var listView: some View {
        List {
            ForEach(viewModel.categorizedItems, id: \.category) { categoryGroup in
                Section(header: Text(categoryGroup.category.rawValue.capitalized)) {
                    ForEach(categoryGroup.items, id: \.id) { item in
                        GroceryItemRow(item: item) {
                            viewModel.toggleItem(item)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView(viewModel: GroceryListViewModel(items: mockItems))
}
