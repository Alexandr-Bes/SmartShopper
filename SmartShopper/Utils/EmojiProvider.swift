//
//  EmojiProvider.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 06.05.2025.
//

import Foundation

protocol EmojiProviderProtocol {
    static func emoji(for name: String) -> String?
}

struct EmojiProvider: EmojiProviderProtocol {
    static func emoji(for name: String) -> String? {
        let key = name.lowercased().trimmingCharacters(in: .whitespaces)
        return groceryEmojiMap[key]
    }
}
