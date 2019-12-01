//
//  GDSplashTableViewCell.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 30.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

class GDSplashTableViewCell: UITableViewCell {
    let gameImage = UIElements().imageView
    let textContainerForMask = UIElements().containerView
    private let coverContainer = UIElements().containerView
    let tintContainer = UIElements().containerView
    var label = UIElements().titleLabel

    let addFavoritesButton: UIButton = {
        let button = UIButton(type: .system)
        let buttonImage = UIImage(named: "favoritesCircleFill")
        button.setImage(buttonImage, for: .normal)
        button.tintColor = UIColor.VGDColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.layer.shadowColor = UIColor.black.cgColor
//        button.layer.shadowRadius = 2.0
//        button.layer.shadowOpacity = 0.4
//        button.layer.shadowOffset = CGSize(width: 2, height: 1)
//        button.layer.masksToBounds = false
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        gameImage.contentMode = .scaleAspectFill
        contentView.addSubview(gameImage)
        NSLayoutConstraint.activate([
            gameImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            gameImage.heightAnchor.constraint(equalToConstant: 400),
            gameImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: 0),
            gameImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            gameImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -0)
            ])

        tintContainer.layer.cornerRadius = 8
        tintContainer.backgroundColor = UIColor.VGDColor.black
        tintContainer.alpha = 0.6
        contentView.addSubview(tintContainer)
        NSLayoutConstraint.activate([
            tintContainer.bottomAnchor.constraint(equalTo: gameImage.bottomAnchor, constant: -8),
            tintContainer.heightAnchor.constraint(equalToConstant: 48),
            tintContainer.widthAnchor.constraint(equalToConstant: 48),
            tintContainer.trailingAnchor.constraint(equalTo: gameImage.trailingAnchor, constant: -8)
            ])

        coverContainer.layer.cornerRadius = 8
        coverContainer.backgroundColor = UIColor.VGDColor.clear
        contentView.addSubview(coverContainer)
        NSLayoutConstraint.activate([
            coverContainer.bottomAnchor.constraint(equalTo: gameImage.bottomAnchor, constant: -8),
            coverContainer.heightAnchor.constraint(equalToConstant: 48),
            coverContainer.widthAnchor.constraint(equalToConstant: 48),
            coverContainer.trailingAnchor.constraint(equalTo: gameImage.trailingAnchor, constant: -8)
            ])

        addFavoritesButton.contentMode = .center
        coverContainer.addSubview(addFavoritesButton)
        NSLayoutConstraint.activate([
            //addFavoritesButton.heightAnchor.constraint(equalToConstant: 16),
            //addFavoritesButton.widthAnchor.constraint(equalToConstant: 32),
            addFavoritesButton.centerXAnchor.constraint(equalTo: coverContainer.centerXAnchor, constant: 0),
            addFavoritesButton.centerYAnchor.constraint(equalTo: coverContainer.centerYAnchor, constant: 0)
            ])

        contentView.addSubview(textContainerForMask)
        NSLayoutConstraint.activate([
            textContainerForMask.topAnchor.constraint(equalTo: gameImage.bottomAnchor, constant: -0),
            textContainerForMask.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -0),
            textContainerForMask.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            textContainerForMask.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -0)
            ])

//        label = UILabel(frame: self.frame)
//        label.center = self.center
//        label.textAlignment = .center
//        label.font = NewYork.black.of(size: 34)
//        gameImage.mask = label

    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        accessoryType = .none
    }

}
