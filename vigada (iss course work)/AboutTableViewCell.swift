//
//  AboutTableViewCell.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 26.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

class AboutTableViewCell: UITableViewCell {

    let aboutView = AboutView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(aboutView)
        NSLayoutConstraint.activate([
            aboutView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            aboutView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -0),
            aboutView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            aboutView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
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
