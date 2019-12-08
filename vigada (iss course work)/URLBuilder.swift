//
//  URLBuilder.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 07.12.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import Foundation

protocol URLBuilderProtocol: AnyObject {
    func result() -> URL

    @discardableResult
    func addPath(path: API.MainPathParameters) -> Self

    @discardableResult
    func addPath(id: String) -> Self

    @discardableResult
    func addQuery(query: String, value: String) -> Self

    @discardableResult
    func addQuery(query: API.QueryParameters, value: String) -> Self

    @discardableResult
    func addOrderingAscending(value: API.Ordering, order: API.Order) -> Self

    @discardableResult
    func reset() -> Self
}

final class URLBuilder {
    private var path = ""
    private var queryItems: [URLQueryItem] = []
}
extension URLBuilder: URLBuilderProtocol {

    func addPath(path: API.MainPathParameters) -> URLBuilder {
        self.path = "/api/\(path.rawValue)"
        return self
    }

    func addPath(id: String) -> URLBuilder {
        self.path = "/api/\(id)"
        return self
    }

    func addQuery(query: String, value: String) -> URLBuilder {
        self.queryItems.append(URLQueryItem(name: query, value: value))
        return self
    }

    func addQuery(query: API.QueryParameters, value: String) -> URLBuilder {
        self.queryItems.append(URLQueryItem(name: query.rawValue, value: value))
        return self
    }

    func addOrderingAscending(value: API.Ordering, order: API.Order) -> URLBuilder {
        if order == .ascending {
            self.queryItems.append(URLQueryItem(name: "ordering", value: value.rawValue))
        } else if order == .descending {
            self.queryItems.append(URLQueryItem(name: "ordering", value: "-\(value.rawValue)"))
        }

        return self
    }

    func result() -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.rawg.io"
        urlComponents.path = path
        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else {
            fatalError("Неправильный урла")
        }
        return url
    }

    func reset() -> URLBuilder {
        path = ""
        queryItems = []
        return self
    }

}
