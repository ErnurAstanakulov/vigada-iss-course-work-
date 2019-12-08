//
//  GithubAuthorizationService.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 28.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import Foundation

final class GithubAuthorizationService {

    private let githubConstants = GithubConstants()
    private let networkService = NetworkService()
    let session: URLSession

    init() {
        let urlSession = URLSessionFactory()
        self.session = urlSession.createDefaultSession()
    }

    func getTokenBy(authViewController: GithubAuthViewController, code: String, completion: @escaping (_ token: String?, _ error: String?) -> Void) {

        var components = URLComponents(string: githubConstants.tokenLink)
        components?.queryItems = [
            URLQueryItem(name: "client_id", value: "\(githubConstants.clientId)"),
            URLQueryItem(name: "client_secret", value: "\(githubConstants.clientSecret)"),
            URLQueryItem(name: "code", value: "\(code)")
        ]
        guard let url = components?.url else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.postData.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")

         let dataTask = session.dataTask(with: request) { data, response, error in
            defer {
                DispatchQueue.main.async {
                    authViewController.dismiss(animated: true, completion: nil)
                }
            }

            if let error = error {
                completion(nil, "\(error.localizedDescription)")
            }

            if let response = response as? HTTPURLResponse {
                let result = self.networkService.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        if let content = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] {
                            if let token = content["access_token"] as? String {
                                completion(token, nil)
                            }
                        }
                    } catch {
                        print(error.localizedDescription)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }

                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }

        }
        dataTask.resume()
    }
}
