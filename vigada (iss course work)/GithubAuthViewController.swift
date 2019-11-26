//
//  GithubAuthViewController.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 24.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import Foundation
import WebKit

protocol GithubAuthViewControllerDelegate: class {
    func handleTokenReceived(token: String)
}

final class GithubAuthViewController: UIViewController {
    weak var delegate: GithubAuthViewControllerDelegate?

    private let webView = WKWebView()
    private let clientId = "78f64659ae5f7ddc1cd3"
    private let clientSecret = "cc1f948e7b3dc5b85eee0acc46552b18560a83e8"

    private var codeGetRequest: URLRequest? {
        guard var urlComponents = URLComponents(string: "https://github.com/login/oauth/authorize") else {
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "scope", value: "gist"),
            URLQueryItem(name: "client_id", value: "\(clientId)")
        ]
        guard let url = urlComponents.url else {
            return nil
        }
        return URLRequest(url: url)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()

        guard let request = codeGetRequest else {
            return
        }
        webView.load(request)
        webView.navigationDelegate = self
    }

    private func setupViews() {
        view.backgroundColor = .white

        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }

    private func getTokenBy(code: String, completion: @escaping (_ token: String?, _ error: String?) -> Void) {

        var components = URLComponents(string: "https://github.com/login/oauth/access_token")
        components?.queryItems = [
            URLQueryItem(name: "client_id", value: "\(clientId)"),
            URLQueryItem(name: "client_secret", value: "\(clientSecret)"),
            URLQueryItem(name: "code", value: "\(code)")
        ]
        guard let url = components?.url else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.postData.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: request) { data, response, error in
            defer {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }

            if let error = error {
                completion(nil, "\(error.localizedDescription)")
            }

            if let response = response as? HTTPURLResponse {
                let result = handleNetworkResponse(response)
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

        }.resume()
    }
}

extension GithubAuthViewController: WKNavigationDelegate {
    func webView(_: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        if let url = navigationAction.request.url, url.scheme == "https" {
            decisionHandler(.allow)
            let targetString = url.absoluteString.replacingOccurrences(of: "#", with: "?")
            guard let components = URLComponents(string: targetString) else {
                return
            }

            if let code = components.queryItems?.first(where: { $0.name == "code" })?.value {
                getTokenBy(code: code, completion: {token, error in
                    if let token = token {
                        self.delegate?.handleTokenReceived(token: token)
                    } else {
                        print(error ?? "ашипка")
                    }
                })
            }
        } else {
            print("Чота не получилося")
            decisionHandler(.cancel)
        }
    }
}
