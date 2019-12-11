//
//  API.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 07.12.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import Foundation

final class API {
    let baseUrl = "https://api.rawg.io/api/"

    enum MainPathParameters: String {
        case games
        case platforms
        case genres
        case creators
        case developers
        case publishers
        case stores
        case empty = ""
    }

    enum QueryParameters: String {
        case search
        case platforms
        case stores
        case developers
        case publishers
        case genres
        case creators
        case dates
        case page
        case pageSize = "page_size"
        case ordering
    }

    enum Ordering: String {
        case name
        case released
        case added
        case created
        case rating
    }

    enum Order: String {
        case ascending
        case descending
    }
}
