//
//  ManageItemsView.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 06.05.2025.
//

import SwiftUI

struct ManageItemsView<ViewModel: GroceryListViewModelProtocol>: View {
    @State var viewModel: ViewModel
    @State private var itemName = ""

    var body: some View {
        List {
            ForEach(viewModel.items) { item in
                Text("\(item.emoji ?? "") \(item.name)")
            }
            .onDelete { indexSet in
                viewModel.items.remove(atOffsets: indexSet)
            }
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 12) {
                TextField("New Item", text: $itemName)
                    .textFieldStyle(.roundedBorder)

                Button {
                    viewModel.addItem(with: itemName)
                    viewModel.sortItems()
                    itemName = ""
                } label: {
                    Label {
                        Text("Add")
                    } icon: {
                        Image(systemName: "plus")
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(.blue)
                    }
                    .glassEffect(.clear)
                }
                .disabled(itemName.isEmpty)
                .buttonStyle(.plain)

            }
            .padding()
        }
        .padding(.bottom, 16)
        .background(.ultraThinMaterial)
    }
}

#Preview {
    ManageItemsView(viewModel: GroceryListViewModel(items: mockItems))
}
