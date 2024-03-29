//
//  SettingNormalTableViewCell.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 26.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

final class SettingNormalTableViewCell: UITableViewCell {

    let settingView = SettingViewNormal()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(settingView)
        NSLayoutConstraint.activate([
            settingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            settingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -0),
            settingView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            settingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
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
