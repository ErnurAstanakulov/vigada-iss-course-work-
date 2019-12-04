//
//  MORecentSearchRequest.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 04.12.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import Foundation
import CoreData

@objc(MORecentSearchRequest)
internal class MORecentSearchRequest: NSManagedObject {
    @NSManaged var recentSearchText: String
    @NSManaged var timeRequest: Double
}
