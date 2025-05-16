//
//  UserDefaultsStorageAdapter.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 15.05.2025.
//

import Foundation

final class UserDefaultsStorageAdapter: LocalStorageAdapter {

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }    

    func get<T, Key>(for key: Key) -> T? where T : Decodable, T : Encodable, Key : KeyValueStorageKey {
        if T.self == Bool.self || T.self == Int.self || T.self == String.self {
            return defaults.object(forKey: key.rawValue) as? T
        }

        guard let data = defaults.data(forKey: key.rawValue) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }

    func set<T, Key>(_ value: T, for key: Key) where T : Decodable, T : Encodable, Key : KeyValueStorageKey {
        if T.self == Bool.self || T.self == Int.self || T.self == String.self {
            defaults.set(T.self, forKey: key.rawValue)
            return
        }

        if let data = try? JSONEncoder().encode(value) {
            defaults.set(data, forKey: key.rawValue)
        }
    }

    func remove<Key>(_ key: Key) where Key : KeyValueStorageKey {
        defaults.removeObject(forKey: key.rawValue)
    }
}
