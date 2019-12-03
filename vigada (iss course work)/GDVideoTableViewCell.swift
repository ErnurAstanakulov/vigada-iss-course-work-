//
//  GDVideoTableViewCell.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 30.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

class GDVideoTableViewCell: UITableViewCell {
    private let stubContainer = UIElements().containerView
    private let tintContainer = UIElements().containerView
    private let coverContainer = UIElements().containerView
    private let allContainer = UIElements().containerView

    let gameImagePreview = UIElements().imageView

    let playButton: UIButton = {
        let button = UIButton(type: .system)
        let buttonImage = UIImage(named: "play")
        button.setImage(buttonImage, for: .normal)
        button.tintColor = UIColor.VGDColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 2.0
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 2, height: 1)
        button.layer.masksToBounds = false
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        allContainer.clipsToBounds = true
        allContainer.layer.cornerRadius = 16
        allContainer.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]

        contentView.addSubview(allContainer)
        NSLayoutConstraint.activate([
            allContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            allContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            allContainer.heightAnchor.constraint(equalToConstant: 248),
            allContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            allContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
            ])

        gameImagePreview.contentMode = .scaleAspectFill
        allContainer.addSubview(gameImagePreview)
        NSLayoutConstraint.activate([
            gameImagePreview.topAnchor.constraint(equalTo: allContainer.topAnchor, constant: 0),
            gameImagePreview.heightAnchor.constraint(equalTo: allContainer.heightAnchor),
            gameImagePreview.leadingAnchor.constraint(equalTo: allContainer.leadingAnchor, constant: 0),
            gameImagePreview.trailingAnchor.constraint(equalTo: allContainer.trailingAnchor, constant: -0)
            ])

        tintContainer.backgroundColor = UIColor.VGDColor.black
        tintContainer.alpha = 0.3
        gameImagePreview.addSubview(tintContainer)
        NSLayoutConstraint.activate([
            tintContainer.topAnchor.constraint(equalTo: allContainer.topAnchor, constant: 0),
            tintContainer.heightAnchor.constraint(equalTo: allContainer.heightAnchor),
            tintContainer.leadingAnchor.constraint(equalTo: allContainer.leadingAnchor, constant: 0),
            tintContainer.trailingAnchor.constraint(equalTo: allContainer.trailingAnchor, constant: -0)
            ])

        coverContainer.layer.cornerRadius = 16
        allContainer.addSubview(coverContainer)
        NSLayoutConstraint.activate([
            coverContainer.topAnchor.constraint(equalTo: allContainer.topAnchor, constant: 0),
            coverContainer.heightAnchor.constraint(equalTo: allContainer.heightAnchor),
            coverContainer.leadingAnchor.constraint(equalTo: allContainer.leadingAnchor, constant: 0),
            coverContainer.trailingAnchor.constraint(equalTo: allContainer.trailingAnchor, constant: -0)
            ])

        coverContainer.addSubview(playButton)
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: allContainer.centerXAnchor, constant: 0),
            playButton.centerYAnchor.constraint(equalTo: allContainer.centerYAnchor, constant: 0)
            ])

//        stubContainer.backgroundColor = .white
//        contentView.addSubview(stubContainer)
//        NSLayoutConstraint.activate([
//            stubContainer.topAnchor.constraint(equalTo: allContainer.bottomAnchor, constant: 8),
//            stubContainer.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: 0),
//            stubContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
//            stubContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -0)
//            ])
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
