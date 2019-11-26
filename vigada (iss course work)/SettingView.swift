//
//  SettingView.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 26.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

class SettingView: UIView {

    let settingNumber = UIElements().descriptionLabel
    let settingLabel = UIElements().descriptionLabel
    let settingButton = UIElements().settingButton

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.translatesAutoresizingMaskIntoConstraints = false

        self.backgroundColor = .white

        settingNumber.font = SFCompactText.bold.of(size: 17)
        settingLabel.font = SFCompactText.regular.of(size: 17)

        addSubview(settingNumber)
        NSLayoutConstraint.activate([
            settingNumber.centerXAnchor.constraint(equalTo: centerXAnchor),
            settingNumber.topAnchor.constraint(equalTo: topAnchor, constant: 0)
            ])

        addSubview(settingButton)
        NSLayoutConstraint.activate([
            settingButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            settingButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            settingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            settingButton.topAnchor.constraint(equalTo: settingNumber.bottomAnchor, constant: 0)
            ])

        addSubview(settingLabel)
        NSLayoutConstraint.activate([
            settingLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            settingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            settingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            settingLabel.topAnchor.constraint(equalTo: settingButton.bottomAnchor, constant: 0),
            settingLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
