//
//  APICollectionData.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 09.12.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import Foundation

final class APICollectionData {
    let urlBuilder = URLBuilder()

    func tableFirstScreen() -> (titles: [String], urls: [URL]) {
        let top70yearsRequestTitle = "top 70 years"
        var top70yearsRequest = urlBuilder.reset().result()
        top70yearsRequest = urlBuilder
            .addPath(path: .games)
            .addQuery(query: .dates, value: "1970-01-01,1979-12-31")
            .addOrderingAscending(value: .rating, order: .descending)
            .result()

        let best2019RequestTitle = "best 2019"
        var best2019Request = urlBuilder.reset().result()
        best2019Request = urlBuilder
            .addPath(path: .games)
            .addQuery(query: .dates, value: "2019-01-01,2019-12-31")
            .addOrderingAscending(value: .rating, order: .descending)
            .result()
        let releaseLastMonthTitle = "Release Last Month"
        var releaseLastMonthRequest = urlBuilder.reset().result()
        releaseLastMonthRequest = urlBuilder
            .addPath(path: .games)
            .addQuery(query: .dates, value: "2019-12-01,2019-12-31")
            .addOrderingAscending(value: .released, order: .descending)
            .result()

        let mostAnticipatedUpcomingTitle = "What are the most anticipated upcoming games?"
        var mostAnticipatedUpcomingRequest = urlBuilder.reset().result()
        mostAnticipatedUpcomingRequest = urlBuilder
            .addPath(path: .games)
            .addQuery(query: .dates, value: "2019-12-10,2020-10-10")
            .addOrderingAscending(value: .added, order: .descending)
            .result()

        let title = [top70yearsRequestTitle, best2019RequestTitle, releaseLastMonthTitle, mostAnticipatedUpcomingTitle]
        let urls = [top70yearsRequest, best2019Request, releaseLastMonthRequest, mostAnticipatedUpcomingRequest]

        return (title, urls)
    }

    func collectionFirstScreen() -> (titles: [String], urls: [URL]) {

        let electronicsArtTitle = "highest rated game by Electronic Arts"
        var electronicsArtRequest = urlBuilder.reset().result()
        electronicsArtRequest = urlBuilder
            .addPath(path: .games)
            .addQuery(query: .developers, value: "109")
            .result()

        let best1990RequestTitle = "Legends 1990-1999"
        var best1990Request = urlBuilder.reset().result()
        best1990Request = urlBuilder
            .addPath(path: .games)
            .addQuery(query: .dates, value: "1990-01-01,1999-12-31")
            .addOrderingAscending(value: .rating, order: .descending)
            .result()

        let ubisoftTitle = "Top by Ubisoft"
        var ubisoftRequest = urlBuilder.reset().result()
        ubisoftRequest = urlBuilder
            .addPath(path: .games)
            .addQuery(query: .developers, value: "405")
            .addOrderingAscending(value: .rating, order: .descending)
            .result()
        let title = [best1990RequestTitle, ubisoftTitle, electronicsArtTitle]
        let urls = [best1990Request, ubisoftRequest, electronicsArtRequest]

        return (title, urls)
    }

    func collectionAllGames() -> (titles: [String], urls: [URL]) {
        let allGamesTitle = "All Video Games in base"
        var allGamesRequest = urlBuilder.reset().result()
        allGamesRequest = urlBuilder
            .addPath(path: .games)
            .result()
        let title = [allGamesTitle]
        let urls = [allGamesRequest]

        return (title, urls)
    }

    func collectionPlatformsGames() -> (titles: [String], urls: [URL]) {
        let linuxTitle = "Linux"
        var linuxRequest = urlBuilder.reset().result()
        linuxRequest = urlBuilder.addPath(path: .games)
            .addQuery(query: .platforms, value: "6")
            .addOrderingAscending(value: .rating, order: .descending)
            .result()

        let pcTitle = "PC\ngames"
        var pcRequest = urlBuilder.reset().result()
        pcRequest = urlBuilder.addPath(path: .games)
            .addQuery(query: .platforms, value: "4")
            .addOrderingAscending(value: .rating, order: .descending)
            .result()

        let iosTitle = "iOS"
        var iosRequest = urlBuilder.reset().result()
        iosRequest = urlBuilder.addPath(path: .games)
            .addQuery(query: .platforms, value: "3")
            .addOrderingAscending(value: .rating, order: .descending)
            .result()

        let xboxTitle = "XBOX"
        var xboxRequest = urlBuilder.reset().result()
        xboxRequest = urlBuilder.addPath(path: .games)
            .addQuery(query: .platforms, value: "1")
            .addOrderingAscending(value: .rating, order: .descending)
            .result()

        let psTitle = "Play\nStation 4"
        var psRequest = urlBuilder.reset().result()
        psRequest = urlBuilder.addPath(path: .games)
            .addQuery(query: .platforms, value: "18")
            .addOrderingAscending(value: .rating, order: .descending)
            .result()

        let androidTitle = "Android"
        var androidRequest = urlBuilder.reset().result()
        androidRequest = urlBuilder.addPath(path: .games)
            .addQuery(query: .platforms, value: "21")
            .addOrderingAscending(value: .rating, order: .descending)
            .result()

        let macosTitle = "macOS"
        var macosRequest = urlBuilder.reset().result()
        macosRequest = urlBuilder.addPath(path: .games)
            .addQuery(query: .platforms, value: "5")
            .addOrderingAscending(value: .rating, order: .descending)
            .result()

        let switchTitle = "Nintendo Switch"
        var switchRequest = urlBuilder.reset().result()
        switchRequest = urlBuilder.addPath(path: .games)
            .addQuery(query: .platforms, value: "7")
            .addOrderingAscending(value: .rating, order: .descending)
            .result()

        let commodoreTitle = "Commodore / Amiga"
        var commodoreRequest = urlBuilder.reset().result()
        commodoreRequest = urlBuilder.addPath(path: .games)
            .addQuery(query: .platforms, value: "166")
            .addOrderingAscending(value: .rating, order: .descending)
            .result()

        let webTitle = "Web"
        var webRequest = urlBuilder.reset().result()
        webRequest = urlBuilder.addPath(path: .games)
            .addQuery(query: .platforms, value: "171")
            .addOrderingAscending(value: .rating, order: .descending)
            .result()

        let gameBoyTitle = "Game Boy"
        var gameBoyRequest = urlBuilder.reset().result()
        gameBoyRequest = urlBuilder.addPath(path: .games)
            .addQuery(query: .platforms, value: "26")
            .addOrderingAscending(value: .rating, order: .descending)
            .result()

        let wiiTitle = "Wii"
        var wiiRequest = urlBuilder.reset().result()
        wiiRequest = urlBuilder.addPath(path: .games)
            .addQuery(query: .platforms, value: "11")
            .addOrderingAscending(value: .rating, order: .descending)
            .result()

        let pspTitle = "PSP"
        var pspRequest = urlBuilder.reset().result()
        pspRequest = urlBuilder.addPath(path: .games)
            .addQuery(query: .platforms, value: "17")
            .addOrderingAscending(value: .rating, order: .descending)
            .result()

        let nesTitle = "NES"
        var nesRequest = urlBuilder.reset().result()
        nesRequest = urlBuilder.addPath(path: .games)
            .addQuery(query: .platforms, value: "49")
            .addOrderingAscending(value: .rating, order: .descending)
            .result()

        let title = [linuxTitle, pcTitle, iosTitle, xboxTitle, psTitle,
                     androidTitle, macosTitle, switchTitle, commodoreTitle,
                     webTitle, gameBoyTitle, wiiTitle, pspTitle, nesTitle]
        let urls = [linuxRequest, pcRequest, iosRequest, xboxRequest, psRequest,
                    androidRequest, macosRequest, switchRequest, commodoreRequest,
                    webRequest, gameBoyRequest, wiiRequest, pspRequest, nesRequest]

        return (title, urls)
    }

    func collectionAges() -> (titles: [String], urls: [URL]) {
        let y40Title = "1940-1969 years"
        var y40Request = urlBuilder.reset().result()
        y40Request = urlBuilder.addPath(path: .games)
            .addQuery(query: .dates, value: "1940-01-01,1969-12-31")
            .addOrderingAscending(value: .rating, order: .descending)
            .result()

        let y70Title = "1970 years"
        var y70Request = urlBuilder.reset().result()
        y70Request = urlBuilder.addPath(path: .games)
            .addQuery(query: .dates, value: "1970-01-01,1979-12-31")
            .addOrderingAscending(value: .rating, order: .descending)
            .result()

        let y80Title = "1980 years"
        var y80Request = urlBuilder.reset().result()
        y80Request = urlBuilder.addPath(path: .games)
            .addQuery(query: .dates, value: "1980-01-01,1989-12-31")
            .addOrderingAscending(value: .rating, order: .descending)
            .result()

        let y90Title = "1990 years"
        var y90Request = urlBuilder.reset().result()
        y90Request = urlBuilder.addPath(path: .games)
            .addQuery(query: .dates, value: "1990-01-01,1999-12-31")
            .addOrderingAscending(value: .rating, order: .descending)
            .result()

        let y00Title = "2k years"
        var y00Request = urlBuilder.reset().result()
        y00Request = urlBuilder.addPath(path: .games)
            .addQuery(query: .dates, value: "2000-01-01,2009-12-31")
            .addOrderingAscending(value: .rating, order: .descending)
            .result()

        let y10Title = "2010 years"
        var y10Request = urlBuilder.reset().result()
        y10Request = urlBuilder.addPath(path: .games)
            .addQuery(query: .dates, value: "2010-01-01,2019-12-31")
            .addOrderingAscending(value: .rating, order: .descending)
            .result()

        let title = [y40Title, y70Title, y80Title, y90Title, y00Title, y10Title]
        let urls = [y40Request, y70Request, y80Request, y90Request, y00Request, y10Request]
        return (title, urls)
    }

}
