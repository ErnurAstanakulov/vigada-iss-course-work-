//
//  GameDescription.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 08.12.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import Foundation

// MARK: - GamesSearchGamesDescription
struct GamesSearchGamesDescription: Codable {
    let descriptionRaw: String

    enum CodingKeys: String, CodingKey {
        case descriptionRaw = "description_raw"
    }
}
