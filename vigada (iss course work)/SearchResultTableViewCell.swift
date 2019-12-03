//
//  SearchResultTableViewCell.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 26.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    private let container = UIElements().containerView
    let gameImageView = UIElements().imageView
    let gameTitle = UIElements().descriptionLabel

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        container.layer.cornerRadius = 16
        container.clipsToBounds = true
        contentView.addSubview(container)
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
            ])

        gameImageView.contentMode = .scaleAspectFill
        container.addSubview(gameImageView)
        NSLayoutConstraint.activate([
            gameImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0),
            gameImageView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -0),
            gameImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 0),
            gameImageView.heightAnchor.constraint(equalToConstant: 80),
            gameImageView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -0)
            ])

        gameTitle.font = SFMono.bold.of(size: 24)
        gameTitle.textAlignment = .left
        gameTitle.textColor = UIColor.VGDColor.white
        gameTitle.backgroundColor = UIColor.VGDColor.black
        gameTitle.numberOfLines = 1
        container.addSubview(gameTitle)
        NSLayoutConstraint.activate([
            gameTitle.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            gameTitle.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8),
            gameTitle.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -16)
            ])
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
