import Foundation
import Observation

@MainActor
@Observable
final class SearchItemsViewModel {
    private let store: SharedViewModel
    private let localStorage: LocalStorageAdapter

    private enum SearchStorageKey: String, KeyValueStorageKey {
        case recentSearches = "recent_searches"
    }

    var query: String = ""
    var recentSearches: [String] = []

    init(store: SharedViewModel, localStorage: LocalStorageAdapter = UserDefaultsStorageAdapter()) {
        self.store = store
        self.localStorage = localStorage
        self.recentSearches = localStorage.get(for: SearchStorageKey.recentSearches, default: [])
    }

    var results: [GroceryItem] {
        store.searchItems(query: query)
    }

    func selectRecent(_ value: String) {
        query = value
    }

    func commitSearch() {
        let normalized = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalized.isEmpty else { return }

        var updated = recentSearches.filter { $0.caseInsensitiveCompare(normalized) != .orderedSame }
        updated.insert(normalized, at: 0)
        if updated.count > 5 {
            updated = Array(updated.prefix(5))
        }

        recentSearches = updated
        localStorage.set(updated, for: SearchStorageKey.recentSearches)
    }

    func item(withID id: String) -> GroceryItem? {
        store.item(withID: id)
    }
}
