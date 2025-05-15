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
    @State private var groceryListViewModel = GroceryListViewModel()

    var body: some View {
        TabView {
            HomeView(viewModel: groceryListViewModel)
                .tabItem { Label("List", systemImage: "list.bullet") }
                .tag(TabTarget.list)

            ReorderItemsView(viewModel: groceryListViewModel)
                .tabItem { Label("Order", systemImage: "arrow.up.arrow.down") }
                .tag(TabTarget.order)

            ManageItemsView(viewModel: groceryListViewModel)
                .tabItem { Label("Manage", systemImage: "plus.circle") }
                .tag(TabTarget.manage)
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

//#Preview {
//    let appManager = AppManagerFactory.makeTesting()
//    return TabsView()
//        .environment(appManager)
//        .onAppear {
//            Task {
//                await appManager.appLaunched()
//            }
//        }
//}
