import SwiftUI

struct SearchItemsView: View {
    @State var viewModel: SearchItemsViewModel
    @State private var path: [String] = []

    var body: some View {
        NavigationStack(path: $path) {
            List {
                if viewModel.query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    if !viewModel.recentSearches.isEmpty {
                        Section(Localization.text(.recentSearches)) {
                            ForEach(viewModel.recentSearches, id: \.self) { value in
                                Button {
                                    viewModel.selectRecent(value)
                                } label: {
                                    Label(value, systemImage: "clock")
                                }
                            }
                        }
                    }
                } else {
                    ForEach(viewModel.results) { item in
                        NavigationLink(value: item.id) {
                            GroceryItemListRow(item: item, trailingStyle: .boughtBadge)
                        }
                    }
                }
            }
            .navigationTitle(Localization.text(.searchTitle))
            .searchable(text: $viewModel.query, prompt: Localization.text(.searchPlaceholder))
            .onSubmit(of: .search) {
                viewModel.commitSearch()
            }
            .onChange(of: viewModel.query) { _, newValue in
                if newValue.isEmpty {
                    path.removeAll()
                }
            }
            .navigationDestination(for: String.self) { id in
                if let item = viewModel.item(withID: id) {
                    ItemDetailsView(item: item)
                } else {
                    ContentUnavailableView(Localization.text(.notFound), systemImage: "exclamationmark.triangle")
                }
            }
        }
    }
}

#Preview {
    SearchItemsView(viewModel: SearchItemsViewModel(store: SharedViewModel(items: mockItems)))
}
