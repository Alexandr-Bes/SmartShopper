import SwiftUI

struct GroceryItemListRow: View {
    @Environment(\.appTheme) private var theme

    let item: GroceryItem
    var trailingStyle: TrailingStyle = .none

    enum TrailingStyle {
        case none
        case boughtBadge
        case toggle(isBought: Bool, action: () -> Void)
    }

    var body: some View {
        HStack(spacing: 12) {
            Text(item.emoji ?? "🛒")
                .font(.title3)
                .frame(width: 36, height: 36)
                .background(theme.rowBadgeBackground)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 2) {
                Text(item.name.capitalized)
                    .font(.body.weight(.medium))
                Text(item.stores.map(\.name).joined(separator: ", "))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer(minLength: 12)

            trailingView
        }
        .padding(.vertical, 2)
    }

    @ViewBuilder
    private var trailingView: some View {
        switch trailingStyle {
        case .none:
            EmptyView()
        case .boughtBadge:
            if item.isBought {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(theme.rowBadgeText)
            }
        case let .toggle(isBought, action):
            Button(action: action) {
                CheckboxView(isChecked: isBought)
                    .foregroundStyle(theme.rowBadgeText)
                    .font(.title2)
//                Image(systemName: isBought ? "checkmark.circle.fill" : "circle")
//                    .foregroundStyle(isBought ? theme.rowBadgeText : .secondary)
//                    .font(.title3)
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    GroceryItemListRow(item: mockItems[1], trailingStyle: .toggle(isBought: true, action: {}))
}
