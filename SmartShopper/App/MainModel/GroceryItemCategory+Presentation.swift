import Foundation

extension GroceryItemCategory {
    var title: String {
        switch self {
        case .fruits: return "Fruits"
        case .vegetables: return "Vegetables"
        case .meat: return "Meat"
        case .fish: return "Fish"
        case .spices: return "Spices"
        case .cerealAndPasta: return "Cereal & Pasta"
        case .seasoning: return "Seasoning"
        case .sweat: return "Sweets"
        case .drinks: return "Drinks"
        case .unCategorized: return "Uncategorized"
        }
    }
}
