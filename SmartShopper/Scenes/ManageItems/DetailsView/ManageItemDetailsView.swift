//
//  ManageItemDetailsView.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 16.02.2026.
//

import SwiftUI

struct ManageItemDetailsView<ViewModel: GroceryListViewModelProtocol>: View {
    @Environment(\.dismiss) private var dismiss

    @State var viewModel: ViewModel
    let itemID: String

    @State private var isShowingEditSheet = false
    @State private var isShowingDeleteConfirmation = false

    private var item: GroceryItem? {
        viewModel.item(withID: itemID)
    }

    var body: some View {
        Group {
            if let item {
                List {
                    Section("Item") {
                        detailsRow(title: "Name", value: item.name)
                        detailsRow(title: "Category", value: item.category.title)
                        detailsRow(title: "Status", value: item.isBought ? "Bought" : "To Buy")
                    }

                    Section("Stores") {
                        ForEach(item.stores) { store in
                            Text(store.name)
                        }
                    }

                    // FIXME: - Remove after -
                    Section("Timeline") {
                        detailsRow(title: "Created", value: item.createdAt.formatted(date: .abbreviated, time: .shortened))
                        detailsRow(title: "Updated", value: item.updatedAt.formatted(date: .abbreviated, time: .shortened))
                        if let lastTimeBought = item.lastTimeBought {
                            detailsRow(
                                title: "Last time bought",
                                value: lastTimeBought.formatted(date: .abbreviated, time: .shortened)
                            )
                        }
                    }

                    Section {
                        Button(role: .destructive) {
                            isShowingDeleteConfirmation = true
                        } label: {
                            Label("Delete Item", systemImage: "trash")
                        }
                    }
                }
            } else {
                ContentUnavailableView("Item not found", systemImage: "exclamationmark.triangle")
            }
        }
        .navigationTitle("Item Details")
        .toolbar {
            if item != nil {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit") {
                        isShowingEditSheet = true
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingEditSheet) {
            if let item {
                ItemEditorSheet(
                    mode: .edit(item),
                    stores: viewModel.stores.sorted(),
                    selectedStore: viewModel.selectedStore
                ) { draft in
                    await viewModel.updateItem(
                        id: item.id,
                        name: draft.name,
                        category: draft.category,
                        stores: draft.stores,
                        isBought: draft.isBought
                    )
                }
            }
        }
        .confirmationDialog("Delete this item?", isPresented: $isShowingDeleteConfirmation, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                Task {
                    await viewModel.deleteItems(ids: [itemID])
                    dismiss()
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This action cannot be undone.")
        }
    }

    @ViewBuilder
    private func detailsRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    ManageItemDetailsView(viewModel: GroceryListViewModel(items: mockItems), itemID: "123")
}
