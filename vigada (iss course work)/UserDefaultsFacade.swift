//
//  UserDefaultsFacade.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 08.12.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import Foundation

enum UserDefaultsFacade {

    static func set(_ object: Any, forKey key: String) {
        let defaults: UserDefaults = UserDefaults.standard
        defaults.set(object, forKey: key)
        defaults.synchronize()
    }

    static func get(forKey key: String) -> AnyObject {
        let defaults: UserDefaults = UserDefaults.standard
        return defaults.object(forKey: key) as AnyObject
    }

    static func check(forKey key: String) -> Bool {
        let defaults: UserDefaults = UserDefaults.standard
        return defaults.bool(forKey: key)
    }

    static func remove(forKey key: String) {
        let defaults: UserDefaults = UserDefaults.standard
        return defaults.removeObject(forKey: key)
    }
}
