//
//  Model.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 24.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import Foundation

enum GameCategory {
    case favorites
    case wishlist
    case recent
    case later
}

struct GameModelForCoreData {
    let gameUuid = UUID()
    let gameIndex: Int16
    let gameCategory: GameCategory
}
