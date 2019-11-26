//
//  SettingModel.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 26.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import Foundation

struct Setting {
    let number: String
    let buttonTitle: String
    let settingTitle: String
    let status: Status

    enum Status {
        case normal
        case active
        case about
    }
}
