//
//  CoreDataManager.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 24.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import Foundation
import CoreData
import UIKit
//TODO удалить потом юайкит отсюда

protocol CoreDataManagerDelegate: class {
    func loadFavoritesFromCoreData(_ segmentDictionary: [String: [GameModel]])
}

final class CoreDataManager: NSObject, NSFetchedResultsControllerDelegate {
    let stack = CoreDataStack.shared

    weak var delegate: CoreDataManagerDelegate?

    var initialState = false

    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<MOGameDetails> = {
        let fetchRequest = NSFetchRequest<MOGameDetails>()
        fetchRequest.entity = MOGameDetails.entity()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
        //fetchRequest.fetchBatchSize = 14
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: stack.persistentContainer.viewContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()

    var gameModels = [GameModel]()

    func loadFavoritesFromCoreData() {
        //fetchedResultsController
        print("loading...")
        // тут всё поменяется конечно

        guard let testImage = UIImage(named: "demo") else {
            print("Картинки Демо нет")
            return
        }
        guard let imageData = testImage.jpegData(compressionQuality: 1) else {
            print("ошибка jpg")
            return
        }

        let link = "https://media.rawg.io/media/stories/a30/a3017aa7740f387a158cbc343524275b.mp4"
        let gameModel1 = GameModel(gameCategory: .best, gameTitle: "Zelda", gameImage: imageData,
                                   gameDescription: string, gameScreenshots: [], gameVideoPreviewImage: nil, gameVideoLink: link)
        let gameModel2 = GameModel(gameCategory: .later, gameTitle: "Cyberpunk 2077", gameImage: imageData,
                                   gameDescription: string, gameScreenshots: [], gameVideoPreviewImage: nil, gameVideoLink: link)
        let gameModel3 = GameModel(gameCategory: .none, gameTitle: "Sims", gameImage: imageData,
                                   gameDescription: string, gameScreenshots: [], gameVideoPreviewImage: nil, gameVideoLink: link)
        let gameModel4 = GameModel(gameCategory: .recent, gameTitle: "Contra", gameImage: imageData,
                                   gameDescription: string, gameScreenshots: [], gameVideoPreviewImage: nil, gameVideoLink: link)
        let gameModel5 = GameModel(gameCategory: .best, gameTitle: "Gorky 17", gameImage: imageData,
                                   gameDescription: string, gameScreenshots: [], gameVideoPreviewImage: nil, gameVideoLink: link)
        let gameModel6 = GameModel(gameCategory: .wishes, gameTitle: "Football Manager", gameImage: imageData,
                                   gameDescription: string, gameScreenshots: [], gameVideoPreviewImage: nil, gameVideoLink: link)

        gameModels = [gameModel1, gameModel2, gameModel3, gameModel4, gameModel5, gameModel6]

        let responseMessages = [Favorites.segmentCells.data[0]: gameModels.filter { $0.gameCategory == .best },
                                Favorites.segmentCells.data[1]: gameModels.filter { $0.gameCategory == .wishes },
                                Favorites.segmentCells.data[2]: gameModels.filter { $0.gameCategory == .later },
                                Favorites.segmentCells.data[3]: gameModels.filter { $0.gameCategory == .recent }]
        self.delegate?.loadFavoritesFromCoreData(responseMessages)
    }

    func saveGame(_ gameModelForKeeping: GameModel) {
        stack.persistentContainer.performBackgroundTask { (context) in

            let newGame = NSEntityDescription.insertNewObject(forEntityName: "GameDetails", into: context)
            //переводим картинку в binary data
            //                guard let imageData = .image.jpegData(compressionQuality: 1) else {
            //                    print("ошибка jpg")
            //                    return
            //                }
            newGame.setValue(gameModelForKeeping.gameUuid, forKey: "gameUuid")
            newGame.setValue(gameModelForKeeping.gameCategory, forKey: "gameCategory")

            do {
                // сохраняем контекст
                try context.save()
                print("Контекст успешно сохранен.")
            } catch {
                print("Ошибка сохранения: \(error)")
            }
        }
    }

    func saveRecentSearchRequestText(_ resentSearchText: String) {
        stack.persistentContainer.performBackgroundTask { (context) in

            let newSearchText = NSEntityDescription.insertNewObject(forEntityName: "RecentSearchRequest", into: context)
            newSearchText.setValue(resentSearchText, forKey: "recentSearchText")
            let timeRequest = Date().timeIntervalSince1970
            newSearchText.setValue(timeRequest, forKey: "timeRequest")
            do {
                // сохраняем контекст
                try context.save()
                print("Контекст успешно сохранен.")
            } catch {
                print("Ошибка сохранения: \(error)")
            }
        }
    }


}
