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
            Picker("Store", selection: $viewModel.selectedStore) {
                ForEach(GroceryStore.allCases, id: \.self) {
                    Text($0.name)
                        .tag($0)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: viewModel.selectedStore) { oldValue, newValue in
                Log.debug("Selected store changed from: \(oldValue) to \(newValue)")
            }
            .padding(.horizontal)

            Picker("Sort by", selection: $viewModel.sortOption) {
                Text("Name").tag(GroceryItemsSortType.name)
                Text("Category").tag(GroceryItemsSortType.category)
                Text("Store").tag(GroceryItemsSortType.store)
            }
            .pickerStyle(.menu)
            .onChange(of: viewModel.sortOption) { //oldValue, newValue in
                viewModel.sortItems()
            }
            .padding()

            if viewModel.items.isEmpty {
                ProgressView()
            }

            listView
        }
    }

    @ViewBuilder var listView: some View {
        List {
            ForEach(viewModel.items) { item in
                HStack {
                    Text(item.name)
                        .padding(.trailing)
                    Text(item.emoji ?? "")
                    Spacer()
                    Image(systemName: item.isBought ? "checkmark.square.fill" : "square")
                        .onTapGesture {
                            viewModel.toggleItem(item)
                        }
                }
            }
        }
    }
}

#Preview {
    HomeView(viewModel: GroceryListViewModel())
}
