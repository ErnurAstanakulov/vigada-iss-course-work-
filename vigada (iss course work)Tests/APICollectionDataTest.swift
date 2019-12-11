//
//  APICollectionDataTest.swift
//  vigada (iss course work)Tests
//
//  Created by Maxim Marchuk on 11.12.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import XCTest
@testable import vigada__iss_course_work_

class APICollectionDataTest: XCTestCase {

    var apiCollectionDataTest: APICollectionData!
    var tupleTitles = 0
    var tupleUrls = 0

    override func setUp() {
        super.setUp()
        apiCollectionDataTest = APICollectionData()
    }

    override func tearDown() {
        apiCollectionDataTest = nil
        tupleTitles = 0
        tupleUrls = 0
        super.tearDown()
    }

    func testTableFirstScreenTitlesAndUrlsCountEquals() {
        // act
        let create = apiCollectionDataTest.tableFirstScreen()

        // assert
        XCTAssertEqual(create.titles.count, create.urls.count, "Не равны")
    }

    func testCollectionFirstScreenTitlesAndUrlsCountEquals() {
        // act
        let create = apiCollectionDataTest.collectionFirstScreen()

        // assert
        XCTAssertEqual(create.titles.count, create.urls.count, "Не равны")
    }

    func testCollectionPlatformsGamesTitlesAndUrlsCountEquals() {
        // act
        let create = apiCollectionDataTest.collectionPlatformsGames()

        // assert
        XCTAssertEqual(create.titles.count, create.urls.count, "Не равны")
    }

    func testCollectionAgesTitlesAndUrlsCountEquals() {
        // act
        let create = apiCollectionDataTest.collectionAges()

        // assert
        XCTAssertEqual(create.titles.count, create.urls.count, "Не равны")
    }

    func testCollectionAllGamesTitlesAndUrlsCountEquals() {
        // act
        let create = apiCollectionDataTest.collectionAllGames()

        // assert
        XCTAssertEqual(create.titles.count, create.urls.count, "Не равны")
    }

}
