//
//  TabsView.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 06.05.2025.
//

import SwiftUI

struct TabsView: View {

    @Environment(AppManager.self) private var appManager
    @State private var selection: TabTarget = .list
    @State private var groceryListViewModel = GroceryListViewModel()

    var body: some View {
        TabView {
            HomeView(viewModel: groceryListViewModel)
                .tabItem { Label("List", systemImage: "list.bullet") }
            ReorderItemsView(viewModel: groceryListViewModel)
                .tabItem { Label("Order", systemImage: "arrow.up.arrow.down") }
            ManageItemsView(viewModel: groceryListViewModel)
                .tabItem { Label("Manage", systemImage: "plus.circle") }
        }
        .onAppear {
            groceryListViewModel.bind(to: appManager)
//            groceryListViewModel.selectedStore = appManager.currentStore
//            Task {
//                await groceryListViewModel.loadItems()
//            }
        }
        .onChange(of: appManager.deepLinkTarget) { _, newValue in
            if let newValue = newValue {
                selection = newValue
            }
        }
    }
}

#Preview {
    TabsView()
        .environment(AppManager())
}
