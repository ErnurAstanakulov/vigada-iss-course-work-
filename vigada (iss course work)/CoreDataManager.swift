//
//  CoreDataManager.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 24.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataManagerDelegate: class {
    func loadFavoritesFromCoreData(_ segmentDictionary: [String: [String]])
}

final class CoreDataManager: NSObject, NSFetchedResultsControllerDelegate {
    let stack = CoreDataStack.shared

    weak var delegate: CoreDataManagerDelegate?

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

    func loadFavoritesFromCoreData() {
        //fetchedResultsController
        print("loading...")
        // тут всё поменяется конечно
        let responseMessages = [Favorites.segmentCells.data[0]: Favorites.best.data,
                                Favorites.segmentCells.data[1]: Favorites.wishes.data,
                                Favorites.segmentCells.data[2]: Favorites.later.data,
                                Favorites.segmentCells.data[3]: Favorites.recent.data]
        self.delegate?.loadFavoritesFromCoreData(responseMessages)
    }

    func saveGame(_ gameModelForKeeping: GameModelForKeeping) {
        stack.persistentContainer.performBackgroundTask { (context) in

            let newGame = NSEntityDescription.insertNewObject(forEntityName: "GameDetails", into: context)
            //переводим картинку в binary data
            //                guard let imageData = .image.jpegData(compressionQuality: 1) else {
            //                    print("ошибка jpg")
            //                    return
            //                }
            newGame.setValue(gameModelForKeeping.gameUuid, forKey: "gameUuid")
            newGame.setValue(gameModelForKeeping.gameIndex, forKey: "gameIndex")
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
}
