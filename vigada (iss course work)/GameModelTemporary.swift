//
//  GameModelTemporary.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 08.12.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import Foundation

struct GameModelTemporary: Hashable {
    let gameId: String
    let gameTitle: String
    let gameImage: Data
    let gameImageLink: String
    let gameDescription: String?
    let gameScreenshots: [Data?]
    let gameScreenshotsLinks: [String?]
    let gameVideoPreviewImage: Data?
    let gameVideoPreviewImageLink: String?
    let gameVideoLink: String?
}
