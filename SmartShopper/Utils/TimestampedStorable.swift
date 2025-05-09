//
//  TimestampedStorable.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 07.05.2025.
//

import Foundation

protocol TimestampedStorable {
    var createdAt: Date? { get }
    var updatedAt: Date? { get }
}
