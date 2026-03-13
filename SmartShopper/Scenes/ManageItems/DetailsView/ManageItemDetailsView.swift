//
//  ManageItemDetailsView.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 16.02.2026.
//

import SwiftUI

struct ManageItemDetailsView: View {
    @Environment(\.dismiss) private var dismiss

    @State var viewModel: ManageItemsViewModel
    let itemID: String

    @State private var isShowingEditSheet = false
    @State private var isShowingDeleteConfirmation = false

    private var item: GroceryItem? {
        viewModel.item(withID: itemID)
    }

    var body: some View {
        Group {
            if let item {
                ItemDetailsView(item: item)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(Localization.text(.editItem)) {
                                isShowingEditSheet = true
                            }
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(role: .destructive) {
                                isShowingDeleteConfirmation = true
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                    }
            } else {
                ContentUnavailableView(Localization.text(.notFound), systemImage: "exclamationmark.triangle")
            }
        }
        .sheet(isPresented: $isShowingEditSheet) {
            if let item {
                ItemEditorSheet(
                    mode: .edit(item),
                    stores: viewModel.stores,
                    selectedStore: viewModel.selectedStore,
                    canUseExpiration: viewModel.canUseExpiration,
                    onPremiumActionTap: { },
                    initialExpirationDays: viewModel.expirationDays(from: item)
                ) { draft in
                    await viewModel.updateItem(
                        id: item.id,
                        name: draft.name,
                        category: draft.category,
                        stores: draft.stores,
                        isBought: draft.isBought,
                        expirationDays: draft.expirationDays
                    )
                }
            }
        }
        .confirmationDialog("Delete this item?", isPresented: $isShowingDeleteConfirmation, titleVisibility: .visible) {
            Button(Localization.text(.delete), role: .destructive) {
                Task {
                    await viewModel.deleteItems(ids: [itemID])
                    dismiss()
                }
            }
            Button(Localization.text(.cancel), role: .cancel) { }
        } message: {
            Text("This action cannot be undone.")
        }
    }
}

#Preview {
    ManageItemDetailsView(
        viewModel: ManageItemsViewModel(
            shared: SharedViewModel(items: mockItems),
            premiumAccess: BasicPremiumAccess(),
            locationService: LocationService()
        ),
        itemID: mockItems[0].id
    )
}
