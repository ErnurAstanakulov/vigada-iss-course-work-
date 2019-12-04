//
//  StrechyHeaderView.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 04.12.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

class StrechyHeaderView: UIView {
    // MARK: - Properties
    private let coverContainer = UIElements().containerView
    let strechyImage = UIElements().imageView
    //let textContainerForMask = UIElements().containerView
    let tintContainer = UIElements().containerView
    let titleGame = UIElements().titleLabel

    let addFavoritesButton: UIButton = {
        let button = UIButton(type: .system)
        let buttonImage = UIImage(named: "fav.add")
        button.setImage(buttonImage, for: .normal)
        button.tintColor = UIColor.VGDColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var label = UIElements().titleLabel

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.translatesAutoresizingMaskIntoConstraints = false

        strechyImage.contentMode = .scaleAspectFill
        addSubview(strechyImage)
        NSLayoutConstraint.activate([
            strechyImage.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            strechyImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            strechyImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            strechyImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
            ])

        tintContainer.layer.cornerRadius = 8
        tintContainer.backgroundColor = UIColor.VGDColor.black
        tintContainer.alpha = 0.6
        addSubview(tintContainer)
        NSLayoutConstraint.activate([
            //tintContainer.bottomAnchor.constraint(equalTo: strechyImage.bottomAnchor, constant: -8),
            tintContainer.centerYAnchor.constraint(equalTo: strechyImage.centerYAnchor, constant: 118),
            tintContainer.heightAnchor.constraint(equalToConstant: 48),
            tintContainer.widthAnchor.constraint(equalToConstant: 48),
            tintContainer.trailingAnchor.constraint(equalTo: strechyImage.trailingAnchor, constant: -8)
            ])

        coverContainer.layer.cornerRadius = 8
        coverContainer.backgroundColor = UIColor.VGDColor.clear
        addSubview(coverContainer)
        NSLayoutConstraint.activate([
            //coverContainer.bottomAnchor.constraint(equalTo: strechyImage.bottomAnchor, constant: -8),
            coverContainer.centerYAnchor.constraint(equalTo: strechyImage.centerYAnchor, constant: 118),
            coverContainer.heightAnchor.constraint(equalToConstant: 48),
            coverContainer.widthAnchor.constraint(equalToConstant: 48),
            coverContainer.trailingAnchor.constraint(equalTo: strechyImage.trailingAnchor, constant: -8)
            ])

        addFavoritesButton.contentMode = .center
        coverContainer.addSubview(addFavoritesButton)
        NSLayoutConstraint.activate([
            addFavoritesButton.centerXAnchor.constraint(equalTo: coverContainer.centerXAnchor, constant: 0),
            addFavoritesButton.centerYAnchor.constraint(equalTo: coverContainer.centerYAnchor, constant: 0)
            ])

        titleGame.font = SFMono.bold.of(size: 28)
        titleGame.textAlignment = .left
        titleGame.textColor = UIColor.VGDColor.white
        titleGame.backgroundColor = UIColor.VGDColor.black
        titleGame.numberOfLines = 5
        addSubview(titleGame)
        NSLayoutConstraint.activate([
            titleGame.bottomAnchor.constraint(equalTo: coverContainer.bottomAnchor, constant: -4),
            titleGame.leadingAnchor.constraint(equalTo: strechyImage.leadingAnchor, constant: 8),
            titleGame.trailingAnchor.constraint(lessThanOrEqualTo: coverContainer.leadingAnchor, constant: -8)
            ])

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
