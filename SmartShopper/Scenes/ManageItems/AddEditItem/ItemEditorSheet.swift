//
//  ItemEditorSheet.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 16.02.2026.
//

import SwiftUI

struct ItemEditorSheet: View {
    @Environment(\.dismiss) private var dismiss

    let mode: Mode
    let stores: [GroceryStore]
    let selectedStore: GroceryStore
    let onSave: (ItemEditorDraft) async -> Bool

    @State private var name: String
    @State private var category: GroceryItemCategory
    @State private var isBought: Bool
    @State private var selectedStoreIDs: Set<String>
    @State private var isSaving = false
    @State private var showError = false

    init(
        mode: Mode,
        stores: [GroceryStore],
        selectedStore: GroceryStore,
        onSave: @escaping (ItemEditorDraft) async -> Bool
    ) {
        self.mode = mode
        self.stores = stores
        self.selectedStore = selectedStore
        self.onSave = onSave

        switch mode {
        case .add:
            _name = State(initialValue: "")
            _category = State(initialValue: .unCategorized)
            _isBought = State(initialValue: false)
            _selectedStoreIDs = State(initialValue: [selectedStore.id])

        case let .edit(item):
            _name = State(initialValue: item.name)
            _category = State(initialValue: item.category)
            _isBought = State(initialValue: item.isBought)
            _selectedStoreIDs = State(initialValue: Set(item.stores.map(\.id)))
        }
    }

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isSaving
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Basic") {
                    TextField("Item name", text: $name)
                        .textInputAutocapitalization(.words)
                    Picker("Category", selection: $category) {
                        ForEach(GroceryItemCategory.allCases, id: \.self) { category in
                            Text(category.title).tag(category)
                        }
                    }
                }

                Section("Stores") {
                    ForEach(stores) { store in
                        Button {
                            toggleStore(store.id)
                        } label: {
                            HStack {
                                Text(store.name)
                                    .foregroundStyle(.primary)
                                Spacer()
                                if selectedStoreIDs.contains(store.id) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.green)
                                }
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }

                if mode.item != nil {
                    Section("Status") {
                        Toggle("Bought", isOn: $isBought)
                        if let lastTimeBought = mode.item?.lastTimeBought {
                            detailsRow(
                                title: "Last time bought",
                                value: lastTimeBought.formatted(date: .abbreviated, time: .shortened)
                            )
                        }
                    }
                }
            }
            .navigationTitle(mode.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(mode.submitLabel) {
                        Task {
                            await save()
                        }
                    }
                    .disabled(!canSave)
                }
            }
            .alert("Could not save item", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please try again.")
            }
        }
    }

    @ViewBuilder
    private func detailsRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.primary)
            Spacer()
            Text(value)
                .multilineTextAlignment(.trailing)
                .foregroundStyle(.secondary)
        }
    }

    private func toggleStore(_ id: String) {
        if selectedStoreIDs.contains(id) {
            selectedStoreIDs.remove(id)
        } else {
            selectedStoreIDs.insert(id)
        }
    }

    @MainActor
    private func save() async {
        guard canSave else { return }

        isSaving = true
        defer { isSaving = false }

        let selectedStores = stores.filter { selectedStoreIDs.contains($0.id) }
        let draft = ItemEditorDraft(
            name: name,
            category: category,
            stores: selectedStores,
            isBought: isBought
        )

        let didSave = await onSave(draft)
        if didSave {
            dismiss()
        } else {
            showError = true
        }
    }

    
    enum Mode {
        case add
        case edit(GroceryItem)

        var title: String {
            switch self {
            case .add: return "Add Item"
            case .edit: return "Edit Item"
            }
        }

        var submitLabel: String {
            switch self {
            case .add: return "Create"
            case .edit: return "Save"
            }
        }

        var item: GroceryItem? {
            switch self {
            case .add: return nil
            case let .edit(item): return item
            }
        }
    }
}


struct ItemEditorDraft {
    let name: String
    let category: GroceryItemCategory
    let stores: [GroceryStore]
    let isBought: Bool
}


#Preview {
    ItemEditorSheet(
        mode: .edit(mockItems[1]),
        stores: mockStores,
        selectedStore: GroceryStore(name: "Hello"),
        onSave: { _ in false }
    )
}
