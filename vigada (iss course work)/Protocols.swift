//
//  Protocols.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 11.12.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

protocol CheckInternetDelegate: class {
    func checkInternet(_ isInternet: Bool)
}

protocol GithubAuthViewControllerDelegate: class {
    func handleTokenReceived(token: String)
}

protocol CollectionCellTapDelegate: class {
    func collectionCellTapped(_ numberCell: Int)
}

protocol BrowseTopTableViewCellTapDelegate: class {
    func topCollectionCellTapped(_ numberCell: Int)
}

protocol BrowsePlatformsTableViewCellTapDelegate: class {
    func platformsCollectionCellTapped(_ numberCell: Int)
}

protocol BrowseAgesTableViewCellTapDelegate: class {
    func agesCollectionCellTapped(_ numberCell: Int)
}

protocol LoggerType {
    func log<T>(message: String, value: T)
}

protocol Font {
    func of(size: CGFloat) -> UIFont?
    func of(textStyle: UIFont.TextStyle, defaultSize: CGFloat, maxSize: CGFloat?) -> UIFont?
}
