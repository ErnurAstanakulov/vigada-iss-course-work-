//
//  FavoritesSegmentControlsModel.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 26.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import Foundation

enum Favorites {
    case first
    case second
    case third
    case fourth
    case segmentCells

    struct FavoritesSegments {
        let segmentsCells = ["Best", "Wishes", "Later", "Recent"]
        let best = ["World Of Warcraft", "Fortnite", "PubG", "Tetris"]
        let wishes = ["Full House", "Dr. Who"]
        var later = ["Full 2", "Dr. 3"]
        let recent = ["iMac Pro", "Mac Mini", "iMac Pro", "Mac Mini"]
    }

    var data: [String] {
        switch self {
        case .first:
            return FavoritesSegments().best
        case .second:
            return FavoritesSegments().wishes
        case .third:
            return FavoritesSegments().later
        case .fourth:
            return FavoritesSegments().recent
        case .segmentCells:
            return FavoritesSegments().segmentsCells
        }
    }
}
