//
//  FavoritesSegmentControlsModel.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 26.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import Foundation

enum Favorites {
    case best
    case wishes
    case later
    case recent
    case segmentCells
    case segmentIcons

    struct FavoritesSegments {
        let segmentsCells = ["Best", "Wishes", "Later", "Recent"]
        let segmentsIcons = ["favoritesPlain", "wishes", "later", "unFavoritesFill"]
        let best = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
        let wishes = ["One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten"]
        var later = ["Mini", "Pro", "Mac", "Book", "iMac", "Apple", "TV", "Arcade", "Xcode", "Swift"]
        let recent = ["Тетрис", "КС", "Симс", "Симсити", "Контра", "Пугб", "Форнайт", "Пятнашки"]
    }

    var data: [String] {
        switch self {
        case .best:
            return FavoritesSegments().best
        case .wishes:
            return FavoritesSegments().wishes
        case .later:
            return FavoritesSegments().later
        case .recent:
            return FavoritesSegments().recent
        case .segmentCells:
            return FavoritesSegments().segmentsCells
        case .segmentIcons:
            return FavoritesSegments().segmentsIcons
        }
    }
}
