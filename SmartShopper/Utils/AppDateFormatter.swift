//
//  AppDateFormatter.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 06.05.2025.
//

import Foundation

protocol DateFormattingService {
    static func format(_ date: Date, style: FormatStyle) -> String
}

enum FormatStyle {
    case short, long, withTime, withMilliseconds
}

struct AppDateFormatter: DateFormattingService {

    private static let dateFormatter = DateFormatter()

    static func format(_ date: Date, style: FormatStyle) -> String {
        switch style {
        case .short: return DateFormatter.shortDate.string(from: date)
        case .long: return DateFormatter.mediumDate.string(from: date)
        case .withTime: return DateFormatter.dateWithTime.string(from: date)
        case .withMilliseconds:
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
            return dateFormatter.string(from: date)
        }
    }
}
