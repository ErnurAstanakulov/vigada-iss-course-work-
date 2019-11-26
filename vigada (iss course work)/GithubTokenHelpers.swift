//
//  GithubTokenHelpers.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 24.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import Foundation

final class GithubTokenStoreManager {
    let githubKey = "githubToken"

    func checkGithubToken() -> Bool {
        return UserDefaults.standard.object(forKey: githubKey) != nil
    }

    func getGithubToken() -> String? {
        return UserDefaults.standard.string(forKey: githubKey)
    }

    func saveGithubToken(value: String) {
        UserDefaults.standard.set(value, forKey: githubKey)
    }

    func removeGithubToken() {
        UserDefaults.standard.removeObject(forKey: githubKey)
    }

}
