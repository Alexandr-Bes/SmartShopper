//
//  LocalStorageAdapter.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 15.05.2025.
//

import Foundation

protocol LocalStorageAdapter {
    func get<T: Codable, Key: KeyValueStorageKey>(for key: Key) -> T?
    func set<T: Codable, Key: KeyValueStorageKey>(_ value: T, for key: Key)
    func remove<Key: KeyValueStorageKey>(_ key: Key)
}

extension LocalStorageAdapter {
    func get<T: Codable, Key: KeyValueStorageKey>(for key: Key, default defaultValue: T) -> T {
        get(for: key) ?? defaultValue
    }
}
