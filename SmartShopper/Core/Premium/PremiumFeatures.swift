//
//  PremiumFeatures.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 22.02.2026.
//

import Foundation

enum PremiumFeature: String, CaseIterable {
    case expirationTracking
    case nearbyStorePreselection
}

protocol PremiumAccessProviding {
    func isEnabled(_ feature: PremiumFeature) -> Bool
}

struct BasicPremiumAccess: PremiumAccessProviding {
    private let enabledFeatures: Set<PremiumFeature>

    init(enabledFeatures: Set<PremiumFeature> = []) {
        self.enabledFeatures = enabledFeatures
    }

    func isEnabled(_ feature: PremiumFeature) -> Bool {
        enabledFeatures.contains(feature)
    }
}
