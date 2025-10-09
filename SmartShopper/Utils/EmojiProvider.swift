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

//TODO: - Is it efficient to always look for first(where: ...)
struct EmojiProvider: EmojiProviderProtocol {
    static func emoji(for name: String) -> String? {
        let key = name.lowercased().trimmingCharacters(in: .whitespaces)
        return groceryEmojiMap.first(where: { key.contains($0.key) })?.value
    }
}
