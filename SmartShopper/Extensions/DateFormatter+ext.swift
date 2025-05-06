//
//  DateFormatter+ext.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 06.05.2025.
//

import Foundation

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short // e.g. 5/6/25
        formatter.timeStyle = .none
        return formatter
    }()

    static let mediumDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium    // e.g. May 6, 2025
        formatter.timeStyle = .none
        return formatter
    }()

    static let dateWithTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium    // e.g. May 6, 2025
        formatter.timeStyle = .full
        return formatter
    }()
}
