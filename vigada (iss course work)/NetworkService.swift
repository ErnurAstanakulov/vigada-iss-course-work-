//
//  NetworkService.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 07.12.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import Foundation

public enum NetworkResponse: String {
    case success
    case authenticationError = "Сначала вам нужно пройти аутентификацию."
    case badRequest = "Неудачный запрос"
    case outdated = "Запрошенный вами URL устарел."
    case failed = "Сбой сетевого запроса."
    case noData = "Ответ вернулся без данных для декодирования."
    case unableToDecode = "Не получилось декодировать ответ."
}

public enum Result<String> {
    case success
    case failure(String)
}

public enum HTTPMethod: String {
    case getData = "GET"
    case postData = "POST"
    case putData = "PUT"
    case patchData = "PATCH"
    case deleteData = "DELETE"
}

final class NetworkService {
    let session: URLSession

    init() {
        let urlSession = URLSessionFactory()
        self.session = urlSession.createDefaultSession()
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

    func getData(at path: String, completion: @escaping (_ data: Data?, _ error: String) -> Void) {
        guard let url = URL(string: path) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.getData.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("VIGADA", forHTTPHeaderField: "User-Agent")

        let dataTask = session.dataTask(with: request) { data, response, error in

            if let error = error {
                completion(nil, "\(error.localizedDescription)")
            }

            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    completion(data, "Успех успешный")
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
        dataTask.resume()
    }

    func getData(at path: URL, completion: @escaping (_ data: Data?, _ error: String) -> Void) {
        var request = URLRequest(url: path)
        request.httpMethod = HTTPMethod.getData.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("VIGADA", forHTTPHeaderField: "User-Agent")

        let dataTask = session.dataTask(with: request) { data, response, error in

            if let error = error {
                completion(nil, "\(error.localizedDescription)")
            }

            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    completion(data, "Успех успешный")
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
        dataTask.resume()
    }

    func downloadData(of path: URL, completion: @escaping (_ data: Data?, _ error: String) -> Void) {
        let downloadTask = session.downloadTask(with: path) { url, response, error in
            guard let url = url else {
                completion(nil, "Плохой url")
                return
            }

            if let error = error {
                completion(nil, "\(error.localizedDescription)")
            }

            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    let data = try? Data(contentsOf: url)
                    completion(data, "Успех успешный")
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
        downloadTask.resume()
    }
}
