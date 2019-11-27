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
        let best = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
        let wishes = ["One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten"]
        var later = ["Mini", "Pro", "Mac", "Book", "iMac", "Apple", "TV", "Arcade", "Xcode", "Swift"]
        let recent = ["Тетрис", "КС", "Симс", "Симсити", "Контра", "Пугб", "Форнайт", "Пятнашки"]
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
