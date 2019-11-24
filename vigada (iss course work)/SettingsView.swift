//
//  SettingsView.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 21.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

final class SettingsView: UIView {

    let settingNumber = UIElements().descriptionLabel
    let settingLabel = UIElements().descriptionLabel
    let settingHiddenLabel = UIElements().descriptionLabel

    let settingButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = NewYork.regular.of(size: 18)
        button.setTitleColor(UIColor.VGDColor.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.translatesAutoresizingMaskIntoConstraints = false

        self.backgroundColor = .white

        settingNumber.font = SFCompactText.bold.of(size: 17)
        settingLabel.font = SFCompactText.regular.of(size: 17)
        settingHiddenLabel.isHidden = true

        addSubview(settingNumber)
        NSLayoutConstraint.activate([
            settingNumber.centerXAnchor.constraint(equalTo: centerXAnchor),
            settingNumber.topAnchor.constraint(equalTo: topAnchor, constant: 8)
            ])

        addSubview(settingButton)
        NSLayoutConstraint.activate([
            settingButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            settingButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            settingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            settingButton.topAnchor.constraint(equalTo: settingNumber.firstBaselineAnchor, constant: 2)
            ])

        addSubview(settingHiddenLabel)
        NSLayoutConstraint.activate([
            settingHiddenLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            settingHiddenLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            settingHiddenLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            settingHiddenLabel.topAnchor.constraint(equalTo: settingNumber.firstBaselineAnchor, constant: 8)
            ])

        addSubview(settingLabel)
        NSLayoutConstraint.activate([
            settingLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            settingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            settingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            settingLabel.topAnchor.constraint(equalTo: settingButton.firstBaselineAnchor, constant: 8),
            settingLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
