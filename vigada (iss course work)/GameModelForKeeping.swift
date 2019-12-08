//
//  Model.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 24.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

enum GameCategory: String {
    case best
    case wishes
    case later
    case recent
}

struct GameModel: Hashable {
    let gameUuid: UUID
    var gameCategory: GameCategory
    let gameNoteCreateTime: Double
    let gameId: String
    let gameTitle: String
    let gameImage: Data
    let gameImageLink: String
    let gameDescription: String
    let gameScreenshots: [Data]
    let gameScreenshotsLinks: [String]
    let gameVideoPreviewImage: Data
    let gameVideoPreviewImageLink: String
    let gameVideoLink: String

    init(gameUuid: UUID = UUID(),
         gameCategory: GameCategory = .recent,
         gameNoteCreateTime: Double = Date().timeIntervalSince1970,
         gameId: String,
         gameTitle: String,
         gameImage: Data,
         gameImageLink: String,
         gameDescription: String,
         gameScreenshots: [Data],
         gameScreenshotsLinks: [String],
         gameVideoPreviewImage: Data,
         gameVideoPreviewImageLink: String,
         gameVideoLink: String) {
        self.gameUuid = gameUuid
        self.gameCategory = gameCategory
        self.gameNoteCreateTime = gameNoteCreateTime
        self.gameId = gameId
        self.gameTitle = gameTitle
        self.gameImage = gameImage
        self.gameImageLink = gameImageLink
        self.gameDescription = gameDescription
        self.gameScreenshots = gameScreenshots
        self.gameScreenshotsLinks = gameScreenshotsLinks
        self.gameVideoPreviewImage = gameVideoPreviewImage
        self.gameVideoPreviewImageLink = gameVideoPreviewImageLink
        self.gameVideoLink = gameVideoLink
    }
}
