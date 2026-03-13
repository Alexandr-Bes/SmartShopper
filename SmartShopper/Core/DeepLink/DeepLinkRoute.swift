//
//  DeepLinkRoute.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 22.02.2026.
//

import Foundation

enum DeepLinkRoute: Equatable {

    case tab(TabTarget)
    case manageItemDetails(itemID: String)
    case homeItemDetails(itemID: String)
    case search(query: String)

    static func parse(url: URL) -> DeepLinkRoute? {
        guard url.scheme == "smartshopper" else { return nil }

        let host = (url.host ?? "").lowercased()
        let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems ?? []

        func value(_ name: String) -> String? {
            queryItems.first(where: { $0.name == name })?.value
        }

        switch host {
        case "list":
            if let itemID = value("itemId"), !itemID.isEmpty {
                return .homeItemDetails(itemID: itemID)
            }
            return .tab(.list)
        case "manage":
            if let itemID = value("itemId"), !itemID.isEmpty {
                return .manageItemDetails(itemID: itemID)
            }
            return .tab(.manage)
        case "order":
            return .tab(.order)
        case "search":
            return .search(query: value("q") ?? "")
        default:
            return nil
        }
    }
}
