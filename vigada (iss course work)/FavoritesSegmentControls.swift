//
//  FavoritesSegmentControls.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 26.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import Foundation

enum Favorites {
    case segmentCells
    case segmentIcons

    struct FavoritesSegments {
        let segmentsCells = ["Best", "Wishes", "Later", "Recent"]
        let segmentsIcons = ["fav.best", "fav.wishes", "fav.later", "fav.recent"]
    }

    var data: [String] {
        switch self {
        case .segmentCells:
            return FavoritesSegments().segmentsCells
        case .segmentIcons:
            return FavoritesSegments().segmentsIcons
        }
    }
}
