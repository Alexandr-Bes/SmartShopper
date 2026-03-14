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
    case search
}

struct TabsView: View {

    @Environment(AppManager.self) private var appManager

    @State private var selection: TabTarget = .list
    @State private var sharedViewModel: SharedViewModel
    @State private var homeViewModel: HomeViewModel
    @State private var manageViewModel: ManageItemsViewModel
    @State private var searchViewModel: SearchItemsViewModel

    @State private var homePath: [String] = []
    @State private var managePath: [String] = []

    init(appManager: AppManager) {
        let sharedVM = SharedViewModel(repository: appManager.groceryRepository)
        _sharedViewModel = State(wrappedValue: sharedVM)
        _homeViewModel = State(wrappedValue: HomeViewModel(shared: sharedVM))
        _manageViewModel = State(
            wrappedValue: ManageItemsViewModel(
                shared: sharedVM,
                premiumAccess: appManager.premiumAccess,
                locationService: appManager.locationService
            )
        )
        _searchViewModel = State(wrappedValue: SearchItemsViewModel(store: sharedVM))
    }

    var body: some View {
        TabView(selection: $selection) {
            Tab(Localization.text(.homeTitle), systemImage: "list.bullet", value: TabTarget.list) {
                NavigationStack(path: $homePath) {
                    HomeView(viewModel: homeViewModel)
                }
            }

            Tab(Localization.text(.orderTitle), systemImage: "arrow.up.arrow.down", value: TabTarget.order) {
                NavigationStack {
                    ReorderItemsView(viewModel: sharedViewModel)
                }
            }

            Tab(Localization.text(.manageTitle), systemImage: "plus.circle", value: TabTarget.manage) {
                NavigationStack(path: $managePath) {
                    ManageItemsView(viewModel: manageViewModel)
                }
            }

            Tab(value: TabTarget.search, role: .search) {
                SearchItemsView(viewModel: searchViewModel)
            }
        }
        .tabBarMinimizeBehavior(.automatic)
        .onChange(of: appManager.deepLinkTarget) { _, newValue in
            if let newValue {
                selection = newValue
            }
        }
        .onChange(of: appManager.deepLinkRoute) { _, route in
            guard let route else { return }

            switch route {
            case let .tab(tab):
                selection = tab
            case let .homeItemDetails(itemID):
                selection = .list
                homePath = [itemID]
            case let .manageItemDetails(itemID):
                selection = .manage
                managePath = [itemID]
            case let .search(query):
                selection = .search
                searchViewModel.query = query
                searchViewModel.commitSearch()
            }

            appManager.deepLinkRoute = nil
        }
    }
}

#Preview {
    let appManager = AppManagerFactory.makeTesting()
    return TabsView(appManager: appManager)
        .environment(appManager)
}
