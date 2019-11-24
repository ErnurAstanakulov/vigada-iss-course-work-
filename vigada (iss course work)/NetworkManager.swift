//
//  NetworkManager.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 24.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import Foundation

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
