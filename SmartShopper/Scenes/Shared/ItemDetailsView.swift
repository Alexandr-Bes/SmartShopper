import SwiftUI

struct ItemDetailsView: View {
    @Environment(\.dismiss) private var dismiss

    let viewModel: ManageItemsViewModel
    let itemID: String

    @State private var isShowingEditSheet = false
    @State private var isShowingDeleteConfirmation = false

    var body: some View {
        Group {
            if let item {
                detailsList(for: item)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                isShowingEditSheet = true
                            } label: {
                                Image(systemName: "square.and.pencil")
                                    .foregroundStyle(Color.black)
                            }
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(role: .destructive) {
                                isShowingDeleteConfirmation = true
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundStyle(Color.red)
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

    private var item: GroceryItem? {
        viewModel.item(withID: itemID)
    }

    private func detailsList(for item: GroceryItem) -> some View {
        List {
            Section(Localization.text(.itemDetails)) {
                detailsRow(title: Localization.text(.itemName), value: item.name)
                detailsRow(title: Localization.text(.category), value: item.category.title)
                detailsRow(title: Localization.text(.status), value: item.isBought ? Localization.text(.bought) : Localization.text(.toBuy))
                if let expirationDate = item.expirationDate {
                    detailsRow(title: Localization.text(.expiration), value: expirationDate.formatted(date: .abbreviated, time: .omitted))
                }
            }

            Section(Localization.text(.stores)) {
                ForEach(item.stores) { store in
                    Text(store.name)
                }
            }

            Section(Localization.text(.timeline)) {
                detailsRow(title: Localization.text(.created), value: item.createdAt.formatted(date: .abbreviated, time: .shortened))
                detailsRow(title: Localization.text(.updated), value: item.updatedAt.formatted(date: .abbreviated, time: .shortened))
            }
        }
        .navigationTitle(Localization.text(.itemDetails))
    }

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
    NavigationStack {
        ItemDetailsView(
            viewModel: ManageItemsViewModel(
                shared: SharedViewModel(items: mockItems),
                premiumAccess: BasicPremiumAccess(),
                locationService: LocationService()
            ),
            itemID: mockItems[0].id
        )
    }
}
