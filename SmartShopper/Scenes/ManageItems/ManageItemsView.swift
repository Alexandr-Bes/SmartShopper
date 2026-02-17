//
//  ManageItemsView.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 06.05.2025.
//

import SwiftUI

struct ManageItemsView<ViewModel: GroceryListViewModelProtocol>: View {
    @State var viewModel: ViewModel
    @State private var isShowingAddSheet = false

    private var groupedItems: [(category: GroceryItemCategory, items: [GroceryItem])] {
        let grouped = Dictionary(grouping: viewModel.items) { $0.category }
        return grouped
            .map { category, items in
                (category: category, items: items.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending })
            }
            .sorted { $0.category < $1.category }
    }

    var body: some View {
        List {
            if viewModel.items.isEmpty {
                EmptyItemsView {
                    isShowingAddSheet = true
                }.listRowBackground(Color.clear)
            } else {
                ForEach(groupedItems, id: \.category) { group in
                    Section(group.category.title) {
                        ForEach(group.items) { item in
                            NavigationLink(value: item.id) {
                                ManageItemRow(item: item)
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    Task {
                                        await viewModel.deleteItems(ids: [item.id])
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Manage Items")
        .navigationDestination(for: String.self) { itemID in
            ManageItemDetailsView(viewModel: viewModel, itemID: itemID)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isShowingAddSheet = true
                } label: {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $isShowingAddSheet) {
            ItemEditorSheet(
                mode: .add,
                stores: viewModel.stores.sorted(),
                selectedStore: viewModel.selectedStore
            ) { draft in
                await viewModel.addItem(name: draft.name, category: draft.category, stores: draft.stores)
            }
        }
    }
}


//FIXME: - Remove
extension GroceryItemCategory {
    var title: String {
        switch self {
        case .fruits: return "Fruits"
        case .vegetables: return "Vegetables"
        case .meat: return "Meat"
        case .fish: return "Fish"
        case .spices: return "Spices"
        case .cerealAndPasta: return "Cereal & Pasta"
        case .seasoning: return "Seasoning"
        case .sweat: return "Sweets"
        case .drinks: return "Drinks"
        case .unCategorized: return "Uncategorized"
        }
    }
}

#Preview {
    NavigationStack {
        ManageItemsView(viewModel: GroceryListViewModel(items: mockItems))
    }
}
