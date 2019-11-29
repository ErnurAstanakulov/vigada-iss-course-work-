//
//  FavoritesSelectActionView.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 29.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

final class FavoritesSelectActionView: UIView {
     // MARK: - Properties
    let containerView = UIElements().containerView
    let favoritesIcon = UIElements().imageView
     // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.VGDColor.green

        self.backgroundColor = UIColor.VGDColor.darkGray
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true

        addSubview(favoritesIcon)
        NSLayoutConstraint.activate([
            favoritesIcon.heightAnchor.constraint(equalToConstant: 48),
            favoritesIcon.widthAnchor.constraint(equalToConstant: 48),
            favoritesIcon.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            favoritesIcon.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0)
            ])
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
