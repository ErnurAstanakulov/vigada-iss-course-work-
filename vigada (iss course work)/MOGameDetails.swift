//
//  MOGameDetails.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 24.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import Foundation
import CoreData

@objc(MOGameDetails)
internal class MOGameDetails: NSManagedObject {

    @NSManaged var gameUuid: UUID
    @NSManaged var gameIndex: Int16
    @NSManaged var gameTimeCreateNote: Double
    @NSManaged var gameCategory: String
    @NSManaged var gameId: Int16
    @NSManaged var gameSlug: String
    @NSManaged var gameName: String
    @NSManaged var gameNameOriginal: String
    @NSManaged var gameDescriptionRaw: String
    @NSManaged var gameMetacritic: Int16
    @NSManaged var gameReleasedTime: Double
    @NSManaged var gameTba: Bool
    @NSManaged var gameInfoUpdatedTime: Double
    @NSManaged var gameBackgroundImage: String
    @NSManaged var gameBackgroundImageAdditional: String
    @NSManaged var gameWebsite: String
    @NSManaged var gameRating: Double
    @NSManaged var gameRatingTop: Double
    @NSManaged var gameAdded: Int16
    @NSManaged var gamePlaytime: Int16
    @NSManaged var gameScreenshotsCount: Int16
    @NSManaged var gameMoviesCount: Int16
    @NSManaged var gameCreatorsCount: Int16
    @NSManaged var gameAchievementsCount: Int16
    @NSManaged var gameRedditUrl: String
    @NSManaged var gameYoutubeCount: Int16
    @NSManaged var gameParentsCount: Int16
    @NSManaged var gameStores: String

}
