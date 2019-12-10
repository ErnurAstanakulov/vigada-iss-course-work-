//
//  NetworkManager.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 24.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import Foundation
import SystemConfiguration

protocol CheckInternetDelegate: class {
    func checkInternet(_ isInternet: Bool)
}

class NetworkManager {
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
        return (isReachable && !needsConnection)
    }

    func getGamesList(url: URL, completion: @escaping (_ gamesList: VGDModelGamesRequest?, _ error: String?) -> Void) {
        networkService.getData(at: url) { data, _  in
            guard let data = data else {
                completion(nil, nil)
                return
            }
            do {
                let vGDModelGamesRequest = try JSONDecoder().decode(VGDModelGamesRequest.self, from: data)
                completion(vGDModelGamesRequest, nil)
            } catch {
                print("\(error.localizedDescription)")
            }

        }
    }

    func getGamesListByStringUrl(url: String, completion: @escaping (_ gamesList: VGDModelGamesRequest?, _ error: String?) -> Void) {
        networkService.getData(at: url, completion: { data, _ in
            guard let data = data else {
                completion(nil, nil)
                return
            }
            do {
                let vGDModelGamesRequest = try JSONDecoder().decode(VGDModelGamesRequest.self, from: data)
                completion(vGDModelGamesRequest, nil)
            } catch {
                print("\(error.localizedDescription)")
            }

        })
    }

    func getGamesDescription(url: String, completion: @escaping (_ gamesList: GamesSearchGamesDescription?, _ error: String?) -> Void) {
        networkService.getData(at: url, completion: { data, _ in
            guard let data = data else {
                completion(nil, nil)
                return
            }
            do {
                let vGDModelGamesRequest = try JSONDecoder().decode(GamesSearchGamesDescription.self, from: data)
                completion(vGDModelGamesRequest, nil)
            } catch {
                print("\(error.localizedDescription)")
            }

        })
    }

    func getImageByStringUrl(url: String, completion: @escaping (_ gameImageData: Data?, _ error: String?) -> Void) {
        networkService.getData(at: url, completion: {data, _ in
            guard let data = data else {
                completion(nil, nil)
                return
            }
            completion(data, nil)
        })
    }

    func preLoadDictionary(title: [String],
                           urls: [URL],
                           completion: @escaping (_ gamesLists: [String: VGDModelGamesRequest]) -> Void) {

        var preLoadDictionary = [String: VGDModelGamesRequest]()

        let titleArray = title
        let urlArray = urls

        let tablePreview = DispatchGroup()
        for index in 0..<titleArray.count {
            let urlLink = urlArray[index]
            tablePreview.enter()
            self.getGamesList(url: urlLink, completion: { gamesList, _ in
                if let list = gamesList {
                    preLoadDictionary[titleArray[index]] = list
                }
                tablePreview.leave()
            })
        }
        tablePreview.notify(queue: .main) {
            completion(preLoadDictionary)
        }
    }

}
