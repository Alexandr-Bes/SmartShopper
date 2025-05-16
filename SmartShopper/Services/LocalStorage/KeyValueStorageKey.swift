//
//  KeyValueStorageKey.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 15.05.2025.
//

import Foundation

protocol KeyValueStorageKey: RawRepresentable where RawValue == String { }

enum UserDefaultsKey: String, KeyValueStorageKey {
    case didSetDefaultItems
}

enum KeychainKey: String, KeyValueStorageKey {
    case username
    case password
    case accessToken
}
