//
//  CoreDataManager.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 24.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataManager {
    let stack = CoreDataStack.shared

    func saveGame(_ gameModelForCoreData: GameModelForCoreData) {

        stack.persistentContainer.performBackgroundTask { (context) in

            let newGame = NSEntityDescription.insertNewObject(forEntityName: "GameDetails", into: context)
            //переводим картинку в binary data
            //                guard let imageData = .image.jpegData(compressionQuality: 1) else {
            //                    print("ошибка jpg")
            //                    return
            //                }
            newGame.setValue(gameModelForCoreData.gameUuid, forKey: "gameUuid")
            newGame.setValue(gameModelForCoreData.gameIndex, forKey: "gameIndex")
            newGame.setValue(gameModelForCoreData.gameCategory, forKey: "gameCategory")

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
