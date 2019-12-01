//
//  GDDescriptionTableViewCell.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 30.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

class GDDescriptionTableViewCell: UITableViewCell {

    let gameDescription = UIElements().descriptionLabel
    let сontainerGameDescription = UIElements().containerView

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(сontainerGameDescription)
        NSLayoutConstraint.activate([
            сontainerGameDescription.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            сontainerGameDescription.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -0),
            сontainerGameDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            сontainerGameDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -0)
            ])

        сontainerGameDescription.addSubview(gameDescription)
        NSLayoutConstraint.activate([
            gameDescription.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            gameDescription.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            gameDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            gameDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
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
