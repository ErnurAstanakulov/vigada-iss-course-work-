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
    case none
}

struct GameModel: Hashable {
    let gameUuid: UUID
    var gameCategory: GameCategory
    let gameCreateInfoTime: Double
    let gameTitle: String
    let gameImage: Data
    let gameDescription: String
    let gameScreenshots: [Data]?
    let gameVideoPreviewImage: Data?
    let gameVideoLink: String

    init(gameUuid: UUID = UUID(),
         gameCategory: GameCategory = .recent,
         gameCreateInfoTime: Double = Date().timeIntervalSince1970,
         gameTitle: String,
         gameImage: Data,
         gameDescription: String,
         gameScreenshots: [Data]?,
         gameVideoPreviewImage: Data?,
         gameVideoLink: String) {
        self.gameUuid = gameUuid
        self.gameCategory = gameCategory
        self.gameCreateInfoTime = gameCreateInfoTime
        self.gameTitle = gameTitle
        self.gameImage = gameImage
        self.gameDescription = gameDescription
        self.gameScreenshots = gameScreenshots
        self.gameVideoPreviewImage = gameVideoPreviewImage
        self.gameVideoLink = gameVideoLink
    }
}

let string = """
Portal 2 is a first-person puzzle game developed by Valve Corporation and released on April 19, 2011 on Steam, PS3 and Xbox 360. It was published by Valve Corporation in digital form and by Electronic Arts in physical form. \n\nIts plot directly follows the first game's, taking place in the Half-Life universe. You play as Chell, a test subject in a research facility formerly ran by the company Aperture Science, but taken over by an evil AI that turned upon its creators, GladOS. After defeating GladOS at the end of the first game but failing to escape the facility, Chell is woken up from a stasis chamber by an AI personality core, Wheatley, as the unkempt complex is falling apart. As the two attempt to navigate through the ruins and escape, they stumble upon GladOS, and accidentally re-activate her...\n\nPortal 2's core mechanics are very similar to the first game's ; the player must make their way through several test chambers which involve puzzles. For this purpose, they possess a Portal Gun, a weapon capable of creating teleportation portals on white surfaces. This seemingly simple mechanic and its subtleties coupled with the many different puzzle elements that can appear in puzzles allows the game to be easy to start playing, yet still feature profound gameplay. The sequel adds several new puzzle elements, such as gel that can render surfaces bouncy or allow you to accelerate when running on them.\n\nThe game is often praised for its gameplay, its memorable dialogue and writing and its aesthetic. Both games in the series are responsible for inspiring most puzzle games succeeding them, particularly first-person puzzle games. The series, its characters and even its items such as the portal gun and the companion cube have become a cultural icon within gaming communities.\n\nPortal 2 also features a co-op mode where two players take on the roles of robots being led through tests by GladOS, as well as an in-depth level editor.
"""
