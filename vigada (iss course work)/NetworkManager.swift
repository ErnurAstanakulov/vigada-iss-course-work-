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

enum NetworkResponse: String {
    case success
    case authenticationError = "Сначала вам нужно пройти аутентификацию."
    case badRequest = "Неудачный запрос"
    case outdated = "Запрошенный вами URL устарел."
    case failed = "Сбой сетевого запроса."
    case noData = "Ответ вернулся без данных для декодирования."
    case unableToDecode = "Не получилось декодировать ответ."
}

enum Result<String> {
    case success
    case failure(String)
}

func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
    switch response.statusCode {
    case 200...299:
        return .success
    case 401...500:
        return .failure(NetworkResponse.authenticationError.rawValue)
    case 501...599:
        return .failure(NetworkResponse.badRequest.rawValue)
    case 600:
        return .failure(NetworkResponse.outdated.rawValue)
    default:
        return .failure(NetworkResponse.failed.rawValue)
    }
}

class NetworkManager {
    weak var delegate: CheckInternetDelegate?

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
}
