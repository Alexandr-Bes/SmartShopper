//
//  ManageItemsView.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 06.05.2025.
//

import SwiftUI

struct ManageItemsView<ViewModel: GroceryListViewModelProtocol>: View {
    @State var viewModel: ViewModel

    @State private var newItemName = ""

    var body: some View {
        VStack {

            List {
                ForEach(viewModel.items) { item in
                    Text("\(item.emoji ?? "") \(item.name)")
                }
                .onDelete { indexSet in
                    viewModel.items.remove(atOffsets: indexSet)
                }
            }

            TextField("New Item", text: $newItemName)
                .textFieldStyle(.roundedBorder)
                .padding()

            Button("Add") {
                let newItem = GroceryItem(
                    name: newItemName,
                    category: .unCategorized,
                    store: .pingoDoce,
                    isBought: false
                )
                viewModel.addItem(newItem)
                viewModel.sortItems()
                newItemName = ""
            }
        }
    }
}

#Preview {
    ManageItemsView(viewModel: GroceryListViewModel())
}
