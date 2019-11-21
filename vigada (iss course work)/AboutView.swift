//
//  SettingsView.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 21.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

final class AboutView: UIView {

    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    let vgdLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = SFMono.bold.of(textStyle: .largeTitle, defaultSize: 34)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let apiLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = SFMono.regular.of(textStyle: .body, defaultSize: 11)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = SFCompactText.regular.of(textStyle: .body, defaultSize: 17)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let workTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = SFCompactText.regular.of(textStyle: .body, defaultSize: 17)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let linkLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = SFMono.regular.of(textStyle: .footnote, defaultSize: 11)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = SFMono.bold.of(size: 34)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.translatesAutoresizingMaskIntoConstraints = false

        self.backgroundColor = .white

        addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            logoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            logoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0)
            ])

        addSubview(vgdLabel)
        NSLayoutConstraint.activate([
            vgdLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            vgdLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -0),
            vgdLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            vgdLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 0)
            ])

        addSubview(apiLabel)
        NSLayoutConstraint.activate([
            apiLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            apiLabel.topAnchor.constraint(equalTo: vgdLabel.lastBaselineAnchor, constant: 8)
            ])

        addSubview(workTitleLabel)
        NSLayoutConstraint.activate([
            workTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            workTitleLabel.topAnchor.constraint(equalTo: apiLabel.firstBaselineAnchor, constant: 16)
            ])

        addSubview(authorLabel)
        NSLayoutConstraint.activate([
            authorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            authorLabel.topAnchor.constraint(equalTo: workTitleLabel.firstBaselineAnchor, constant: 8)
            ])

        addSubview(linkLabel)
        NSLayoutConstraint.activate([
            linkLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            linkLabel.topAnchor.constraint(equalTo: authorLabel.firstBaselineAnchor, constant: 8)
            ])

        addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dateLabel.topAnchor.constraint(equalTo: linkLabel.bottomAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8)
            ])

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
