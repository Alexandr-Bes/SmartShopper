//
//  HomeView.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 05.05.2025.
//

import SwiftUI

struct HomeView: View {
    @State var viewModel: HomeViewModel

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
            if let item = viewModel.item(withID: itemID) {
                ItemDetailsView(item: item)
            } else {
                ContentUnavailableView(Localization.text(.notFound), systemImage: "exclamationmark.triangle")
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                storePickerView
            }
            ToolbarItem(placement: .topBarTrailing) {
                sortItemsView
            }
        }
//        .animation(.snappy, value: viewModel.sections)
    }

    @ViewBuilder
    var storePickerView: some View {
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
    HomeView(viewModel: HomeViewModel(shared: SharedViewModel(items: mockItems)))
}
