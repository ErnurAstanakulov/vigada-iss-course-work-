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
    private let gameIndex: Int16 = 1238
    private let content = "text"
    private let gameCategory = GameCategory.favorites
    private var model: GameModelForKeeping!

    override func setUp() {
        super.setUp()
        model = GameModelForKeeping(gameIndex: gameIndex, gameCategory: gameCategory)
    }

    override func tearDown() {
        model = nil
        super.tearDown()
    }

    func testThatGameModelForKeepingIsStruct() {
        // arrange

        // act
        guard let model = model, let displayStyle = Mirror(reflecting: model).displayStyle else {
            XCTFail()
            return
        }
        // assert
        XCTAssertEqual(displayStyle, .struct)
    }

    func testThatGameModelForKeepingWhenInitSetGameIndex() {
        // arrange
        let model = GameModelForKeeping(gameIndex: gameIndex, gameCategory: gameCategory)
        // act

        // assert
        XCTAssertEqual(gameIndex, model.gameIndex)
    }

    func testThatGameModelForKeepingWhenInitSetDefaultUid() {
        // arrange
        let modelTest = GameModelForKeeping(gameIndex: gameIndex, gameCategory: gameCategory)
        // act

        // assert
        XCTAssertNotEqual(model.gameUuid, modelTest.gameUuid)
    }

    func testThatGameModelForKeepingWhenInitSetGameCategory() {
        // arrange

        // act

        // assert
        XCTAssertEqual(model.gameCategory, gameCategory)
    }

}
