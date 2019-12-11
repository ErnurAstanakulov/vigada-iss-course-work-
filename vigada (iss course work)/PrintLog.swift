//
//  PrintLog.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 28.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import Foundation

protocol LoggerType {
    func log<T>(message: String, value: T)
}

enum TypeMessage: String {
    case info = "ℹ️ [Info] - "
    case warning = "⚠️ [Warning] - "
    case error = "🤬 [Error] - "
    case debug = "🤖 [Debug] - "
}

struct VGDLogger {
    let type: LoggerType

    func log<T>(message: String, value: T) {
        let timestamp = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .medium, timeStyle: .long)
        print("VIGADA LOG (\(timestamp.localizedUppercase)):")
        type.log(message: message, value: value)
    }
}

struct Warning: LoggerType {
    func log<T>(message: String, value: T) {
        print("\(TypeMessage.warning.rawValue.uppercased()) \(message.capitalized): \(value)")
    }
}

struct Error: LoggerType {
    func log<T>(message: String, value: T) {
        print("\(TypeMessage.error.rawValue.uppercased()) \(message.capitalized): \(value)")
    }
}

struct Info: LoggerType {
    func log<T>(message: String, value: T) {
        print("\(TypeMessage.info.rawValue.uppercased()) \(message.capitalized): \(value)")
    }
}

struct Debug: LoggerType {
    func log<T>(message: String, value: T) {
        print("\(TypeMessage.debug.rawValue.uppercased()) \(message.capitalized): \(value)")
    }
}
