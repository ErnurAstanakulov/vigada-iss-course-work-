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
    let githubAuthDescription = UIElements().descriptionLabel

    let githubAuthButton: UIButton = {
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
        githubAuthDescription.font = SFCompactText.regular.of(size: 17)

        addSubview(settingNumber)
        NSLayoutConstraint.activate([
            settingNumber.centerXAnchor.constraint(equalTo: centerXAnchor),
            settingNumber.topAnchor.constraint(equalTo: topAnchor, constant: 8)
            ])

        addSubview(githubAuthButton)
        NSLayoutConstraint.activate([
            githubAuthButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            githubAuthButton.topAnchor.constraint(equalTo: settingNumber.firstBaselineAnchor, constant: 2)
            ])
        addSubview(githubAuthDescription)
        NSLayoutConstraint.activate([
            githubAuthDescription.centerXAnchor.constraint(equalTo: centerXAnchor),
            githubAuthDescription.topAnchor.constraint(equalTo: githubAuthButton.firstBaselineAnchor, constant: 8),
            githubAuthDescription.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
