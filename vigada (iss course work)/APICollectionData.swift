//
//  APICollectionData.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 09.12.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import Foundation

class APICollectionData {
    let urlBuilder = URLBuilder()

    func tableFirstScreen() -> (titles: [String], urls: [URL]) {
        let top70yearsRequestTitle = "top 70 years"
        let top70yearsRequest = urlBuilder
            .addPath(path: .games)
            .addQuery(query: .dates, value: "1970-01-01,1979-12-31")
            .addOrderingAscending(value: .rating, order: .descending)
            .result()

        let best2019RequestTitle = "best 2019"
        let best2019Request = urlBuilder
            .addPath(path: .games)
            .addQuery(query: .dates, value: "2019-01-01,2019-12-31")
            .addOrderingAscending(value: .rating, order: .descending)
            .result()
        let releaseLastMonthTitle = "Release Last Month"
        let releaseLastMonthRequest = urlBuilder
            .addPath(path: .games)
            .addQuery(query: .dates, value: "2019-12-01,2019-12-31")
            .addOrderingAscending(value: .released, order: .descending)
            .result()

        let mostAnticipatedUpcomingTitle = "What are the most anticipated upcoming games?"
        let mostAnticipatedUpcomingRequest = urlBuilder
            .addPath(path: .games)
            .addQuery(query: .dates, value: "2019-12-10,2020-10-10")
            .addOrderingAscending(value: .added, order: .descending)
            .result()

        let title = [top70yearsRequestTitle, best2019RequestTitle, releaseLastMonthTitle, mostAnticipatedUpcomingTitle]
        let urls = [top70yearsRequest, best2019Request, releaseLastMonthRequest, mostAnticipatedUpcomingRequest]

        return (title, urls)
    }

    func collectionFirstScreen() -> (titles: [String], urls: [URL]) {

//        let electronicsArtTitle = "highest rated game by Electronic Arts"
//        let electronicsArtRequest = urlBuilder
//            .addPath(path: .games)
//            .addQuery(query: .developers, value: "109")
//            .addOrderingAscending(value: .rating, order: .descending)
//            .result()

        let best1990RequestTitle = "Legends 1990-1999"
        let best1990Request = urlBuilder
            .addPath(path: .games)
            .addQuery(query: .dates, value: "1990-01-01,1999-12-31")
            .addOrderingAscending(value: .rating, order: .descending)
            .result()

        let ubisoftTitle = "Top by Ubisoft"
        let ubisoftRequest = urlBuilder
            .addPath(path: .games)
            .addQuery(query: .developers, value: "405")
            .addOrderingAscending(value: .rating, order: .descending)
            .result()
        let title = [best1990RequestTitle, ubisoftTitle]
        let urls = [best1990Request, ubisoftRequest]

        return (title, urls)
    }

    func collectionAllGames() -> (titles: [String], urls: [URL]) {
        let allGamesTitle = "All Video Games in base"
        let allGamesRequest = urlBuilder
            .addPath(path: .games)
            .addOrderingAscending(value: .rating, order: .descending)
            .result()
        let title = [allGamesTitle]
        let urls = [allGamesRequest]

        return (title, urls)
    }

}
