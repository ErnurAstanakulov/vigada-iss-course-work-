//
//  GithubAuthViewController.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 24.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import Foundation
import WebKit

final class GithubAuthViewController: UIViewController {
    // MARK: - Properties
    weak var delegate: GithubAuthViewControllerDelegate?

    private let webView = WKWebView()
    private let githubConstants = GithubConstants()
    private let githubAuthorizationService = GithubAuthorizationService()

    private var codeGetRequest: URLRequest? {
        guard var urlComponents = URLComponents(string: githubConstants.authorizationLink) else {
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "scope", value: "gist"),
            URLQueryItem(name: "client_id", value: "\(githubConstants.clientId)")
        ]
        guard let url = urlComponents.url else {
            return nil
        }
        return URLRequest(url: url)
    }
    // MARK: - UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()

        guard let request = codeGetRequest else {
            return
        }
        webView.load(request)
        webView.navigationDelegate = self
    }
    // MARK: Set up
    private func setupViews() {
        view.backgroundColor = UIColor.VGDColor.white

        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
}
// MARK: - Extensions
extension GithubAuthViewController: WKNavigationDelegate {
    func webView(_: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        if let url = navigationAction.request.url, url.scheme == "https" {
            decisionHandler(.allow)
            let targetString = url.absoluteString.replacingOccurrences(of: "#", with: "?")
            guard let components = URLComponents(string: targetString) else {
                return
            }

            if let code = components.queryItems?.first(where: { $0.name == "code" })?.value {
                githubAuthorizationService.getTokenBy(authViewController: self, code: code, completion: {token, error in
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
