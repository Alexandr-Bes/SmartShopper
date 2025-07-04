//
//  ReorderItemsView.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 06.05.2025.
//

import SwiftUI

struct ReorderItemsView: View {
    @State var viewModel: GroceryListViewModelProtocol

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.items) { item in
                    Text("\(item.emoji ?? "") \(item.name)")
                }
                .onMove { from, to in
                    viewModel.items.move(fromOffsets: from, toOffset: to)
                    for (index, item) in viewModel.items.enumerated() {
                        viewModel.items[index].sortIndex = index
                    }
                    viewModel.sortItems()
                }
            }
            .navigationTitle("Reorder Items")
            .toolbar { EditButton() }
        }
    }
}

#Preview {
    ReorderItemsView(viewModel: GroceryListViewModel(items: mockItems))
}
