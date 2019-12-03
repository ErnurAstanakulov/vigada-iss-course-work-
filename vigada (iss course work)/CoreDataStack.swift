//
//  CoreDataStack.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 24.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import Foundation
import CoreData

internal final class CoreDataStack {

    static let shared: CoreDataStack = {
        let coreDataStack = CoreDataStack()
        return coreDataStack
    }()

    let persistentContainer: NSPersistentContainer

    private init() {
        let group = DispatchGroup()
        persistentContainer = NSPersistentContainer(name: "VGDModel")
        group.enter()
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            group.leave()
        }
        group.wait()
    }
}
