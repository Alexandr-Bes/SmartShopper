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
            storePickerView

            sortItemsView

            if viewModel.items.isEmpty {
                ProgressView()
            }

            listView
        }
    }

    @ViewBuilder var storePickerView: some View {
        Picker("Store", selection: $viewModel.selectedStore) {
            ForEach(mockStores, id: \.self) {
                Text($0.name)
                    .tag($0)
            }
        }
        .pickerStyle(.segmented)
        .onChange(of: viewModel.selectedStore) { oldValue, newValue in
            Log.debug("Selected store changed from: \(oldValue) to \(newValue)")
        }
        .padding(.horizontal)
    }

    @ViewBuilder var sortItemsView: some View {
        Picker("Sort by", selection: $viewModel.sortOption) {
            Text("Name").tag(GroceryItemsSortType.name)
            Text("Category").tag(GroceryItemsSortType.category)
        }
        .pickerStyle(.menu)
        .onChange(of: viewModel.sortOption) {
            viewModel.sortItems()
        }
        .padding()
    }

    @ViewBuilder var listView: some View {
        List {
            ForEach(viewModel.items, id: \.id) { item in
                GroceryItemRow(item: item) {
                    viewModel.toggleItem(item)
                }
            }
        }
    }
}

#Preview {
    HomeView(viewModel: GroceryListViewModel(items: mockItems))
}
