//
//  PreLoader.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 09.12.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import Foundation

class PreLoader {

    let networkManager = NetworkManager()

    func preLoadDictionary(title: [String],
                           urls: [URL],
                           completion: @escaping (_ gamesLists: [String: VGDModelGamesRequest]) -> Void) {

        var preLoadDictionary = [String: VGDModelGamesRequest]()

        let titleArray = title
        let urlArray = urls

        let tablePreview = DispatchGroup()
        for index in 0..<titleArray.count {
            let urlLink = urlArray[index]
            tablePreview.enter()
            self.networkManager.getGamesList(url: urlLink, completion: { gamesList, _ in
                if let list = gamesList {
                    preLoadDictionary[titleArray[index]] = list
                }
                tablePreview.leave()
            })
        }
        tablePreview.notify(queue: .main) {
            completion(preLoadDictionary)
        }
    }
}
