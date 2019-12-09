//
//  CoreDataManager.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 24.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataManager: NSObject, NSFetchedResultsControllerDelegate {
    let stack = CoreDataStack.shared

    var gameModels = [GameModel]()

    func loadFavoritesFromCoreData(completion: @escaping (_ dictionary: [String: [GameModel]]) -> Void) {
        gameModels.removeAll()
        stack.persistentContainer.performBackgroundTask { (context) in
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "GameDetails")
            request.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(request) as? [MOGameDetails]

                guard let games = result else {
                    fatalError("не скастовалося")
                }
                for game in games {
                    guard let category = GameCategory(rawValue: game.gameCategory) else {
                        fatalError("с категориями из кор даты что-то")
                    }
                    let gameModel = GameModel(gameUuid: game.gameUuid,
                                         gameCategory: category,
                                         gameNoteCreateTime: game.gameNoteCreateTime,
                                         gameId: game.gameId,
                                         gameTitle: game.gameTitle,
                                         gameImage: game.gameImage,
                                         gameImageLink: game.gameImageLink,
                                         gameDescription: game.gameDescription,
                                         gameScreenshots: game.gameScreenshots,
                                         gameScreenshotsLinks: game.gameScreenshotsLinks,
                                         gameVideoPreviewImage: game.gameVideoPreviewImage,
                                         gameVideoPreviewImageLink: game.gameVideoPreviewImageLink,
                                         gameVideoLink: game.gameVideoLink)
                    self.gameModels.append(gameModel)
                }

                let favoritesDictionary = [Favorites.segmentCells.data[0]: self.gameModels.filter { $0.gameCategory == .best },
                                           Favorites.segmentCells.data[1]: self.gameModels.filter { $0.gameCategory == .wishes },
                                           Favorites.segmentCells.data[2]: self.gameModels.filter { $0.gameCategory == .later },
                                           Favorites.segmentCells.data[3]: self.gameModels.filter { $0.gameCategory == .recent }]
                completion(favoritesDictionary)

            } catch {
                print("Ашипкафечареквестафаворе")
            }
        }
    }

    func saveGame(_ gameModelForKeeping: GameModel) {
        stack.persistentContainer.performBackgroundTask { (context) in

            // ищем игру по уиду в базе, если есть, то апдейтим ей только категорию
            // если нет, то создаем новую игру в базе
            let fetchRequest: NSFetchRequest<MOGameDetails> = NSFetchRequest(entityName: "GameDetails")
            fetchRequest.predicate = NSPredicate(format: "gameUuid == %@", gameModelForKeeping.gameUuid as NSUUID)
            do {
                let game = try context.fetch(fetchRequest)
                if let gameUpdate = game.first {
                    gameUpdate.setValue(gameModelForKeeping.gameCategory.rawValue, forKey: "gameCategory")
                } else {
                    let newGame = NSEntityDescription.insertNewObject(forEntityName: "GameDetails", into: context)
                    newGame.setValue(gameModelForKeeping.gameUuid, forKey: "gameUuid")
                    newGame.setValue(gameModelForKeeping.gameCategory.rawValue, forKey: "gameCategory")
                    newGame.setValue(gameModelForKeeping.gameNoteCreateTime, forKey: "gameNoteCreateTime")
                    newGame.setValue(gameModelForKeeping.gameId, forKey: "gameId")
                    newGame.setValue(gameModelForKeeping.gameTitle, forKey: "gameTitle")
                    newGame.setValue(gameModelForKeeping.gameImage, forKey: "gameImage")
                    newGame.setValue(gameModelForKeeping.gameImageLink, forKey: "gameImageLink")
                    newGame.setValue(gameModelForKeeping.gameDescription, forKey: "gameDescription")
                    newGame.setValue(gameModelForKeeping.gameScreenshots, forKey: "gameScreenshots")
                    newGame.setValue(gameModelForKeeping.gameScreenshotsLinks, forKey: "gameScreenshotsLinks")
                    newGame.setValue(gameModelForKeeping.gameVideoPreviewImage, forKey: "gameVideoPreviewImage")
                    newGame.setValue(gameModelForKeeping.gameVideoPreviewImageLink, forKey: "gameVideoPreviewImageLink")
                    newGame.setValue(gameModelForKeeping.gameVideoLink, forKey: "gameVideoLink")
                }
            } catch {
                print("Ошибка фетча gameUuid: \(error)")
            }

            do {
                // сохраняем контекст
                try context.save()
                print("Контекст c моделью успешно сохранен или обновлён")
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
                print("Контекст с поисковым запросом успешно сохранен.")
            } catch {
                print("Ошибка сохранения: \(error)")
            }
        }
    }

}
