//
//  GameModelForKeepingTest.swift
//  vigada (iss course work)Tests
//
//  Created by Maxim Marchuk on 25.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import XCTest
@testable import vigada__iss_course_work_

class GameModelForKeepingTest: XCTestCase {

    private let gameUuid = UUID()
    private let content = "text"
    private let gameCategory = GameCategory.best
    private var model: GameModel!

    override func setUp() {
        super.setUp()
        //model = GameModel(gameCategory: gameCategory)
    }

    override func tearDown() {
        model = nil
        super.tearDown()
    }

}
