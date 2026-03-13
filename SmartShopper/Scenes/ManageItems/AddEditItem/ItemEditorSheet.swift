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
    let canUseExpiration: Bool
    let onPremiumActionTap: () -> Void
    let initialExpirationDays: Int?
    let onSave: (ItemEditorDraft) async -> Bool

    @State private var name: String
    @State private var category: GroceryItemCategory
    @State private var isBought: Bool
    @State private var selectedStoreIDs: Set<String>
    @State private var isSaving = false
    @State private var showError = false
    @State private var isExpirationEnabled: Bool
    @State private var expirationDays: Int

    init(
        mode: Mode,
        stores: [GroceryStore],
        selectedStore: GroceryStore,
        canUseExpiration: Bool,
        onPremiumActionTap: @escaping () -> Void,
        initialExpirationDays: Int?,
        onSave: @escaping (ItemEditorDraft) async -> Bool
    ) {
        self.mode = mode
        self.stores = stores
        self.selectedStore = selectedStore
        self.canUseExpiration = canUseExpiration
        self.onPremiumActionTap = onPremiumActionTap
        self.initialExpirationDays = initialExpirationDays
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

        _isExpirationEnabled = State(initialValue: initialExpirationDays != nil)
        _expirationDays = State(initialValue: max(1, initialExpirationDays ?? 7))
    }

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isSaving
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(Localization.text(.itemDetails)) {
                    TextField(Localization.text(.itemName), text: $name)
                        .textInputAutocapitalization(.words)
                    Picker(Localization.text(.category), selection: $category) {
                        ForEach(GroceryItemCategory.allCases, id: \.self) { category in
                            Text(category.title).tag(category)
                        }
                    }
                }

                Section(Localization.text(.stores)) {
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
                    Section(Localization.text(.status)) {
                        Toggle(Localization.text(.bought), isOn: $isBought)
                    }
                }

                Section(Localization.text(.expiration)) {
                    if canUseExpiration {
                        Toggle(Localization.text(.expirationEnabled), isOn: $isExpirationEnabled)

                        if isExpirationEnabled {
                            Stepper(value: $expirationDays, in: 1...365) {
                                Text(String(format: Localization.text(.expirationDays), expirationDays))
                            }
                        }
                    } else {
                        Button {
                            onPremiumActionTap()
                        } label: {
                            Label(Localization.text(.premiumLocked), systemImage: "crown")
                        }
                        Text(Localization.text(.premiumFeature))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle(mode.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(Localization.text(.cancel)) {
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
            isBought: isBought,
            expirationDays: isExpirationEnabled && canUseExpiration ? expirationDays : nil
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
            case .add: return Localization.text(.addItem)
            case .edit: return Localization.text(.editItem)
            }
        }

        var submitLabel: String {
            switch self {
            case .add: return Localization.text(.create)
            case .edit: return Localization.text(.save)
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
    let expirationDays: Int?
}

#Preview {
    ItemEditorSheet(
        mode: .edit(mockItems[1]),
        stores: mockStores,
        selectedStore: mockStores[0],
        canUseExpiration: true,
        onPremiumActionTap: { },
        initialExpirationDays: 7,
        onSave: { _ in false }
    )
}
