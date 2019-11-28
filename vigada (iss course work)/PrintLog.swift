//
//  PrintLog.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 28.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import Foundation

public func printLog<T>(message: String, value: T) {
    let timestamp = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .medium, timeStyle: .long)
    print("\n VIGADA LOG (\(timestamp.localizedUppercase)): - \(message): \(value) \n")
}
