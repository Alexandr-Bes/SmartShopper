import SwiftUI

struct ItemDetailsView: View {
    let item: GroceryItem

    var body: some View {
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
    ItemDetailsView(item: mockItems[0])
}
