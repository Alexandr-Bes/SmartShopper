//
//  Localization.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 22.02.2026.
//

import Foundation

enum Localization {
    enum Key: String {
        case homeTitle = "home.title"
        case manageTitle = "manage.title"
        case orderTitle = "order.title"
        case searchTitle = "search.title"
        case addItem = "item.add"
        case editItem = "item.edit"
        case itemDetails = "item.details"
        case itemName = "item.name"
        case category = "item.category"
        case stores = "item.stores"
        case status = "item.status"
        case bought = "item.status.bought"
        case toBuy = "item.status.to_buy"
        case delete = "common.delete"
        case cancel = "common.cancel"
        case save = "common.save"
        case create = "common.create"
        case searchPlaceholder = "search.placeholder"
        case recentSearches = "search.recent"
        case emptyItemsTitle = "empty.items.title"
        case emptyItemsSubtitle = "empty.items.subtitle"
        case addNewItem = "item.add_new"
        case expiration = "item.expiration"
        case expirationEnabled = "item.expiration.enabled"
        case expirationDays = "item.expiration.days"
        case premiumLocked = "premium.locked"
        case premiumFeature = "premium.feature"
        case successAdded = "item.added.success"
        case timeline = "item.timeline"
        case created = "item.created"
        case updated = "item.updated"
        case notFound = "item.not_found"
    }

    static func text(_ key: Key) -> String {
        NSLocalizedString(key.rawValue, comment: "")
    }
}
