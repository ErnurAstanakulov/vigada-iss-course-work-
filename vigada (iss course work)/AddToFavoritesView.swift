//
//  AddToFavoritesView.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 01.12.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

final class AddToFavoritesView: UIView {
    // MARK: - Properties
    //private let addFavoritesIcon = UIElements().imageView
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 8
        //self.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 2, height: 1)
        self.layer.masksToBounds = false

//        addFavoritesIcon.image = UIImage(named: "favoritesCircleFill")?.tinted(with: UIColor.VGDColor.white)
//        addSubview(addFavoritesIcon)
//        NSLayoutConstraint.activate([
//            addFavoritesIcon.heightAnchor.constraint(equalToConstant: 24),
//            addFavoritesIcon.widthAnchor.constraint(equalToConstant: 24),
//            addFavoritesIcon.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
//            addFavoritesIcon.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0)
//            ])
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
