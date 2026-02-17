//
//  TabsView.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 06.05.2025.
//

import SwiftUI

enum TabTarget: String, Hashable {
    case list
    case order
    case manage
}

struct TabsView: View {

    @Environment(AppManager.self) private var appManager

    @State private var selection: TabTarget = .list
    @State private var groceryListViewModel: GroceryListViewModel
    @State private var searchQuery: String = ""

    init(appManager: AppManager) {
        _groceryListViewModel = State(
            wrappedValue: GroceryListViewModel(repository: appManager.groceryRepository)
        )
    }

    var body: some View {
        TabView {
            Tab("List", systemImage: "list.bullet") {
                NavigationStack {
                    HomeView(viewModel: groceryListViewModel)
                        .tag(TabTarget.list)
                        .toolbarBackground(.blue)
                }
            }

            Tab("Order", systemImage: "arrow.up.arrow.down") {
                NavigationStack {
                    ReorderItemsView(viewModel: groceryListViewModel)
                        .tag(TabTarget.order)
                }
            }

            Tab("Manage", systemImage: "plus.circle") {
                NavigationStack {
                    ManageItemsView(viewModel: groceryListViewModel)
                        .tag(TabTarget.manage)
                }
            }

            Tab(role: .search) {
                Image(systemName: "globe")
            }
        }
        .searchable(text: $searchQuery)
        .tabBarMinimizeBehavior(.automatic)
        .onChange(of: appManager.deepLinkTarget) { _, newValue in
            if let newValue = newValue {
                selection = newValue
            }
        }
    }
}

#Preview {
    let appManager = AppManagerFactory.makeTesting()
    return TabsView(appManager: appManager)
        .environment(appManager)
}
