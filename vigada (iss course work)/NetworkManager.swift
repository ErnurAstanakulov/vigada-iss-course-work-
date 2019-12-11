//
//  NetworkManager.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 24.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import Foundation
import SystemConfiguration

final class NetworkManager {
    weak var delegate: CheckInternetDelegate?

    let networkService = NetworkService()

    func checkInternet() {
        self.delegate?.checkInternet(isConnectedToNetwork())
    }

    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags = SCNetworkReachabilityFlags()

        if let defaultRouteReachability = defaultRouteReachability {
            if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
                return false
            }
        }

        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let logger = VGDLogger(type: Info())
        logger.log(message: "Интернет", value: (isReachable && !needsConnection))
        return (isReachable && !needsConnection)
    }

    func getGamesList(url: URL, completion: @escaping (_ gamesList: VGDModelGamesRequest?, _ error: String?) -> Void) {
        networkService.getData(at: url) { data, _  in
            var logger = VGDLogger(type: Info())
            logger.log(message: "Скачиваю список игр по урлу", value: url)
            guard let data = data else {
                logger.log(message: "Скачивание описания игры не удалось", value: "getGamesList")
                completion(nil, nil)
                completion(nil, nil)
                return
            }
            do {
                let vGDModelGamesRequest = try JSONDecoder().decode(VGDModelGamesRequest.self, from: data)
                completion(vGDModelGamesRequest, nil)
            } catch {
                logger = VGDLogger(type: Error())
                logger.log(message: "Ошибка", value: "\(error.localizedDescription)")
            }

        }
    }

    func getGamesListByStringUrl(url: String, completion: @escaping (_ gamesList: VGDModelGamesRequest?, _ error: String?) -> Void) {
        networkService.getData(at: url, completion: { data, _ in
            var logger = VGDLogger(type: Info())
            logger.log(message: "Скачиваю список игр по текстовому урлу", value: url)
            guard let data = data else {
                logger = VGDLogger(type: Error())
                logger.log(message: "Скачивание описания игры не удалось", value: "getGamesListByStringUrl")
                completion(nil, nil)
                return
            }
            do {
                let vGDModelGamesRequest = try JSONDecoder().decode(VGDModelGamesRequest.self, from: data)
                completion(vGDModelGamesRequest, nil)
            } catch {
                logger = VGDLogger(type: Error())
                logger.log(message: "Ошибка", value: "\(error.localizedDescription)")
            }

        })
    }

    func getGamesDescription(url: String, completion: @escaping (_ gamesList: GamesSearchGamesDescription?, _ error: String?) -> Void) {
        networkService.getData(at: url, completion: { data, _ in
            var logger = VGDLogger(type: Info())
            logger.log(message: "Скачиаю описание игры по адресу", value: url)
            guard let data = data else {
                logger = VGDLogger(type: Error())
                logger.log(message: "Скачивание описания игры не удалось", value: "getGamesDescription")
                completion(nil, nil)
                return
            }
            do {
                let vGDModelGamesRequest = try JSONDecoder().decode(GamesSearchGamesDescription.self, from: data)
                completion(vGDModelGamesRequest, nil)
            } catch {
                logger = VGDLogger(type: Error())
                logger.log(message: "Ошибка", value: "\(error.localizedDescription)")
            }

        })
    }

    func getImageByStringUrl(url: String, completion: @escaping (_ gameImageData: Data?, _ error: String?) -> Void) {
        networkService.getData(at: url, completion: {data, _ in
            var logger = VGDLogger(type: Info())
            logger.log(message: "Скачиваю картинку по этому строковому урлу", value: url)
            guard let data = data else {
                logger = VGDLogger(type: Error())
                logger.log(message: "Функция: getImageByStringUrl \ndata не data, guard не прошел", value: "nil")
                completion(nil, nil)
                return
            }
            completion(data, nil)
        })
    }

    func preLoad(_ inputTuple: (titles: [String], urls: [URL]),
                 completion: @escaping (_ gamesLists: [String: (image: Data, model: VGDModelGamesRequest)]) -> Void) {

        var preLoadDictionary = [String: (Data, VGDModelGamesRequest)]()

        let titleArray = inputTuple.titles
        let urlArray = inputTuple.urls

        // Получаем на входе тюпл с массивом татйлов и урлов. Урлы в цикле обходим и скачиваем модели.
        // Из модели(списка игр) случайным образом выбераем обложку и скачиваем её.
        // После всех манипуляций формируем выходной словарь.
        // В качестве ключа тайтл, в качестве значения тюпл с картинкой-обложкой и моделью

        let tablePreview = DispatchGroup()
        for index in 0..<titleArray.count {
            let urlLink = urlArray[index]
            tablePreview.enter()
            var logger = VGDLogger(type: Info())
            logger.log(message: "Загружаю линк", value: urlLink)
            self.getGamesList(url: urlLink, completion: { gamesList, _ in
                if let list = gamesList {
                    let quntityOfGames = list.results?.count ?? 1
                    let random = Int.random(in: 1...quntityOfGames)
                    if let imageLink = gamesList?.results?[random - 1].backgroundImage {
                        logger.log(message: "загружаю картинку для обложки", value: imageLink)
                        self.getImageByStringUrl(url: imageLink, completion: { data, _ in
                            guard let data = data else {
                                logger = VGDLogger(type: Warning())
                                logger.log(message: "data не data, guard не прошел", value: "nil")
                                return
                            }
                            preLoadDictionary[titleArray[index]] = (data, list)
                            logger = VGDLogger(type: Info())
                            logger.log(message: "Словарь готов. Покидаю сеанс", value: titleArray[index])
                            tablePreview.leave()
                        })
                    }
                }
            })
        }
        tablePreview.notify(queue: .main) {
            let logger = VGDLogger(type: Info())
            logger.log(message: "Отдаю словарь", value: preLoadDictionary.keys)
            completion(preLoadDictionary)
        }
    }

}
