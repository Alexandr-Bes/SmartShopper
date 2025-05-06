//
//  AppLogger.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 06.05.2025.
//

import Foundation

enum AppLoggerType: String {
    case network
    case system
    case basic
}

enum LogEvent: String {
   case error = "[‼️]"
   case info = "[ℹ️]"
   case debug = "[🔬]"
   case warning = "[⚠️]"
   case severe = "[🔥]"
}

// swiftlint:disable all

final class Log {
    private static var isLoggingEnabled: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    // MARK: - Logging methods

    /// Logs error messages on console with prefix [‼️]
    ///
    /// - Parameters:
    ///   - object: Object or message to be logged
    ///   - filename: File name from where loggin to be done
    ///   - line: Line number in file from where the logging is done
    ///   - column: Column number of the log message
    ///   - funcName: Name of the function from where the logging is done
    static func error( _ object: Any, filename: String = #file, line: Int = #line, funcName: String = #function) {
        if isLoggingEnabled {
            Swift.print(
                """
                \(AppDateFormatter.format(Date(), style: .withTime)) 
                \(LogEvent.error.rawValue)[\(sourceFileName(filePath: filename))] 
                Line: \(line) Func Name: \(funcName) \n\t-> \(object)
                """
            )
        }
    }

    /// Logs info messages on console with prefix [ℹ️]
    ///
    /// - Parameters:
    ///   - object: Object or message to be logged
    ///   - filename: File name from where loggin to be done
    ///   - line: Line number in file from where the logging is done
    ///   - column: Column number of the log message
    ///   - funcName: Name of the function from where the logging is done
    static func info( _ object: Any, filename: String = #file, line: Int = #line, funcName: String = #function) {
        if isLoggingEnabled {
            Swift.print("\(AppDateFormatter.format(Date(), style: .withTime)) \(LogEvent.info.rawValue)[\(sourceFileName(filePath: filename))] Line: \(line) Func Name: \(funcName) \n\t-> \(object)")
        }
    }

    /// Logs debug messages on console with prefix [🔬]
    ///
    /// - Parameters:
    ///   - object: Object or message to be logged
    ///   - filename: File name from where loggin to be done
    ///   - line: Line number in file from where the logging is done
    ///   - column: Column number of the log message
    ///   - funcName: Name of the function from where the logging is done
    static func debug( _ object: Any, filename: String = #file, line: Int = #line, funcName: String = #function) {
        if isLoggingEnabled {
            Swift.print("\(AppDateFormatter.format(Date(), style: .withTime)) \(LogEvent.debug.rawValue)[\(sourceFileName(filePath: filename))] Line: \(line) Func Name: \(funcName) \n\t-> \(object)")
        }
    }

    /// Logs warnings verbosely on console with prefix [⚠️]
    ///
    /// - Parameters:
    ///   - object: Object or message to be logged
    ///   - filename: File name from where loggin to be done
    ///   - line: Line number in file from where the logging is done
    ///   - column: Column number of the log message
    ///   - funcName: Name of the function from where the logging is done
    static func warning( _ object: Any, filename: String = #file, line: Int = #line, funcName: String = #function) {
        if isLoggingEnabled {
            Swift.print("\(AppDateFormatter.format(Date(), style: .withTime)) \(LogEvent.warning.rawValue)[\(sourceFileName(filePath: filename))] Line: \(line) Func Name: \(funcName) \n\t-> \(object)")
        }
    }

    /// Logs severe events on console with prefix [🔥]
    ///
    /// - Parameters:
    ///   - object: Object or message to be logged
    ///   - filename: File name from where loggin to be done
    ///   - line: Line number in file from where the logging is done
    ///   - column: Column number of the log message
    ///   - funcName: Name of the function from where the logging is done
    static func severe( _ object: Any, filename: String = #file, line: Int = #line, funcName: String = #function) {
        if isLoggingEnabled {
            Swift.print("\(AppDateFormatter.format(Date(), style: .withTime)) \(LogEvent.severe.rawValue)[\(sourceFileName(filePath: filename))] Line: \(line) Func Name: \(funcName) \n\t-> \(object)")
        }
    }

    /// Extract the file name from the file path
    ///
    /// - Parameter filePath: Full file path in bundle
    /// - Returns: File Name with extension
    static func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
}

// swiftlint:enable all

// MARK: - Custom Print -

/// This won't print your input if it is in Release Mode. The function will execute only in Debug Mode.
/// You can change name of the flag (DEBUG_MODE)  in Project -> Build settings -> Swift Compiler - Custom Flags
public func print(_ items: String..., filename: String = #file, function: String = #function, line: Int = #line, separator: String = " ", terminator: String = "\n") {
    #if DEBUG
        let pretty = "\(URL(fileURLWithPath: filename).lastPathComponent) [#\(line)] \(function)\n\t-> "
        let output = items.map { "\($0)" }.joined(separator: separator)
        Swift.print(pretty+output, terminator: terminator)
    #endif
}

/// This won't print your input if it is in Release Mode. The function will execute only in Debug Mode.
/// You can change name of the flag (DEBUG_MODE)  in Project -> Build settings -> Swift Compiler - Custom Flags
public func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
        let output = items.map { "\($0)" }.joined(separator: separator)
        Swift.print(output, terminator: terminator)
    #endif
}
