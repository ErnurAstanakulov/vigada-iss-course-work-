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

        gameImagePreview.contentMode = .scaleAspectFill
        gameImagePreview.layer.cornerRadius = 16
        contentView.addSubview(gameImagePreview)
        NSLayoutConstraint.activate([
            gameImagePreview.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            gameImagePreview.heightAnchor.constraint(equalToConstant: 100),
            gameImagePreview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            gameImagePreview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
            ])

        tintContainer.layer.cornerRadius = 16
        tintContainer.backgroundColor = UIColor.VGDColor.black
        tintContainer.alpha = 0.3
        contentView.addSubview(tintContainer)
        NSLayoutConstraint.activate([
            tintContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            tintContainer.heightAnchor.constraint(equalToConstant: 100),
            tintContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            tintContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
            ])

        coverContainer.layer.cornerRadius = 16
        //tintContainer.backgroundColor = UIColor.VGDColor.black
        contentView.addSubview(coverContainer)
        NSLayoutConstraint.activate([
            coverContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            coverContainer.heightAnchor.constraint(equalToConstant: 100),
            coverContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            coverContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
            ])

        coverContainer.addSubview(playButton)
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: gameImagePreview.centerXAnchor, constant: 0),
            playButton.centerYAnchor.constraint(equalTo: gameImagePreview.centerYAnchor, constant: 0)
            ])

        contentView.addSubview(stubContainer)
        NSLayoutConstraint.activate([
            stubContainer.topAnchor.constraint(equalTo: gameImagePreview.bottomAnchor, constant: -0),
            stubContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            stubContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            stubContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -0)
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
