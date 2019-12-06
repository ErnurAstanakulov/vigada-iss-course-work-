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
    @NSManaged var gameCategory: String
    @NSManaged var gameNoteCreateTime: Double
    @NSManaged var gameId: String
    @NSManaged var gameTitle: String
    @NSManaged var gameImage: Data
    @NSManaged var gameImageLink: String
    @NSManaged var gameDescription: String
    @NSManaged var gameScreenshots: [Data]
    @NSManaged var gameScreenshotsLinks: [String]
    @NSManaged var gameVideoPreviewImage: Data
    @NSManaged var gameVideoPreviewImageLink: String
    @NSManaged var gameVideoLink: String
}
