//
//  ManageItemsView.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 06.05.2025.
//

import SwiftUI

struct ManageItemsView: View {
    @Environment(\.appTheme) private var theme

    private let buttonHeight: CGFloat = 60

    @State var viewModel: ManageItemsViewModel
    @State private var isShowingAddSheet = false
    @State private var showAddedFeedback = false
    @State private var showPremiumInfo = false

    var body: some View {
        List {
            if viewModel.items.isEmpty {
                EmptyItemsView()
                    .listRowBackground(Color.clear)
            } else {
                ForEach(viewModel.sections) { group in
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
                                    Label(Localization.text(.delete), systemImage: "trash")
                                }
                                .tint(theme.destructive)
                            }
                        }
                    }
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            Color.clear
                .frame(height: buttonHeight)
        }
        .navigationTitle(Localization.text(.manageTitle))
        .navigationDestination(for: String.self) { itemID in
            ManageItemDetailsView(viewModel: viewModel, itemID: itemID)
        }
        .overlay(alignment: .bottom) {
            AddButton {
                addNewItemAction()
            }
            .padding(.horizontal)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    addNewItemAction()
                } label: {
                    Label(Localization.text(.addItem), systemImage: "plus")
                }
            }
        }
        .overlay(alignment: .bottom) {
            if showAddedFeedback {
                Label(Localization.text(.successAdded), systemImage: "checkmark.circle.fill")
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, buttonHeight)
            }
        }
        .animation(.snappy, value: viewModel.sections)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: showAddedFeedback)
        .sheet(isPresented: $isShowingAddSheet) {
            ItemEditorSheet(
                mode: .add,
                stores: viewModel.stores,
                selectedStore: viewModel.suggestedStoreForNewItem ?? viewModel.selectedStore,
                canUseExpiration: viewModel.canUseExpiration,
                onPremiumActionTap: { showPremiumInfo = true },
                initialExpirationDays: nil
            ) { draft in
                let didSave = await viewModel.addItem(
                    name: draft.name,
                    category: draft.category,
                    stores: draft.stores,
                    expirationDays: draft.expirationDays
                )

                if didSave {
                    showAddedFeedback = true
                    Task {
                        try? await Task.sleep(for: .seconds(1.3))
                        await MainActor.run {
                            showAddedFeedback = false
                        }
                    }
                }
                return didSave
            }
        }
        .alert(Localization.text(.premiumLocked), isPresented: $showPremiumInfo) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(Localization.text(.premiumFeature))
        }
    }

    private func addNewItemAction() {
        viewModel.loadSuggestedStore()
        isShowingAddSheet = true
    }
}

#Preview {
    NavigationStack {
        let premiumAccess = BasicPremiumAccess(enabledFeatures: [.expirationTracking,
                                                                 .nearbyStorePreselection])
        ManageItemsView(viewModel:
            ManageItemsViewModel(
                shared: SharedViewModel(items: mockItems),
                premiumAccess: premiumAccess,
                locationService: LocationService()
            )
        )
    }
}
