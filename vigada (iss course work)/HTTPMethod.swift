//
//  HTTPMethod.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 24.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case getData = "GET"
    case postData = "POST"
    case putData = "PUT"
    case patchData = "PATCH"
    case deleteData = "DELETE"
}
