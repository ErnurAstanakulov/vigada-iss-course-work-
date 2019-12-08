//
//  GamesListModel.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 07.12.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import Foundation

// MARK: - VGDModelGamesRequest
struct VGDModelGamesRequest: Codable {
    let count: Int?
    let next: String?
    let results: [VGDModelResult]?
    enum CodingKeys: String, CodingKey {
        case count
        case next
        case results
    }
}

// MARK: - VGDModelResult
struct VGDModelResult: Codable {
    let id: Int?
    let slug: String?
    let name: String?
    let backgroundImage: String?
    let clip: VGDModelClip?
    let shortScreenshots: [VGDModelShortScreenshot]?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case slug = "slug"
        case name = "name"
        case backgroundImage = "background_image"
        case clip = "clip"
        case shortScreenshots = "short_screenshots"
    }
}

// MARK: - VGDModelClip
struct VGDModelClip: Codable {
    let clips: VGDModelClips?
    let preview: String?

    enum CodingKeys: String, CodingKey {
        case clips
        case preview
    }
}

// MARK: - VGDModelClips
struct VGDModelClips: Codable {
    let full: String?

    enum CodingKeys: String, CodingKey {
        case full
    }
}

// MARK: - VGDModelShortScreenshot
struct VGDModelShortScreenshot: Codable {
    let id: Int?
    let image: String?

    enum CodingKeys: String, CodingKey {
        case id
        case image
    }
}
