//
//  AddToFavoritesStubView.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 06.12.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

class AddToFavoritesStubView: UIView {

    private let tintContainer = UIElements().containerView
    private let clearContainer = UIElements().containerView
    private let textLabel = UIElements().descriptionLabel

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.VGDColor.clear

        tintContainer.layer.cornerRadius = 16
        tintContainer.backgroundColor = UIColor.VGDColor.yellow
        tintContainer.alpha = 0.3
        tintContainer.layer.shadowColor = UIColor.black.cgColor
        tintContainer.layer.shadowRadius = 2.0
        tintContainer.layer.shadowOpacity = 0.4
        tintContainer.layer.shadowOffset = CGSize(width: 1, height: 3)
        tintContainer.layer.masksToBounds = false
        addSubview(tintContainer)
        NSLayoutConstraint.activate([
            tintContainer.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            tintContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            tintContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            tintContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
            ])

        textLabel.text = "You need to watch or add some games to one of the categories."
        textLabel.textColor = UIColor.VGDColor.black
        textLabel.font = SFMono.regular.of(size: 17)
        textLabel.numberOfLines = 8
        addSubview(textLabel)
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: tintContainer.centerXAnchor, constant: 0),
            textLabel.centerYAnchor.constraint(equalTo: tintContainer.centerYAnchor, constant: -0),
            textLabel.leadingAnchor.constraint(equalTo: tintContainer.leadingAnchor, constant: 8),
            textLabel.trailingAnchor.constraint(equalTo: tintContainer.trailingAnchor, constant: -8)
            ])

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
