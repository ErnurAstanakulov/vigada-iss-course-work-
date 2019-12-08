//
//  HomeCollectionViewCell.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 07.12.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    private let allContainer = UIElements().containerView
    private let imageContainer = UIElements().containerView
    let topImage = UIElements().imageView
    let title = UIElements().titleLabel

    override init(frame: CGRect) {
        super.init(frame: .zero)

        allContainer.layer.cornerRadius = 16
        allContainer.layer.shadowColor = UIColor.VGDColor.black.cgColor
        allContainer.layer.shadowRadius = 3
        allContainer.layer.shadowOpacity = 0.4
        allContainer.layer.shadowOffset = CGSize(width: 2, height: 5)
        allContainer.layer.masksToBounds = false
        allContainer.alpha = 1
        allContainer.backgroundColor = UIColor.VGDColor.clear

        contentView.addSubview(allContainer)
        NSLayoutConstraint.activate([
            allContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            allContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            allContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            allContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
            ])

        topImage.layer.cornerRadius = 16
        topImage.image = UIImage(named: "placeholder2")
        topImage.contentMode = .scaleAspectFill
        allContainer.addSubview(topImage)
        NSLayoutConstraint.activate([
            topImage.leadingAnchor.constraint(equalTo: allContainer.leadingAnchor, constant: 0),
            topImage.trailingAnchor.constraint(equalTo: allContainer.trailingAnchor, constant: -0),
            topImage.topAnchor.constraint(equalTo: allContainer.topAnchor, constant: 0),
            topImage.bottomAnchor.constraint(equalTo: allContainer.bottomAnchor, constant: -0)
            ])

        title.textColor = UIColor.VGDColor.white
        title.text = " CYKA BLYAT  "
        title.textAlignment = .right
        title.numberOfLines = 0
        title.alpha = 0.8
        let randomInt = Int.random(in: 18...36)
        title.font = SFMono.bold.of(size: CGFloat(randomInt))
        title.backgroundColor = UIColor.VGDColor.black
        allContainer.addSubview(title)
        randomCoordinateTitle()
    }

    func randomCoordinateTitle() {
        let leftOrRight = Bool.random()
        let topOrBottom = Bool.random()
        var leftText = NSLayoutConstraint()
        var rightText = NSLayoutConstraint()
        var topOrBootomText = NSLayoutConstraint()
        if leftOrRight {
            leftText = title.leadingAnchor.constraint(equalTo: topImage.leadingAnchor, constant: -8)
            rightText = title.trailingAnchor.constraint(lessThanOrEqualTo: topImage.trailingAnchor, constant: 0)
        } else {
            rightText = title.leadingAnchor.constraint(greaterThanOrEqualTo: topImage.leadingAnchor, constant: 0)
            leftText = title.trailingAnchor.constraint(equalTo: topImage.trailingAnchor, constant: 8)
        }
        let verticalRandom = Int.random(in: 16...40)
        if topOrBottom {
            topOrBootomText = title.topAnchor.constraint(equalTo: topImage.topAnchor, constant: CGFloat(verticalRandom))
        } else {
            topOrBootomText = title.bottomAnchor.constraint(equalTo: topImage.bottomAnchor, constant: -CGFloat(verticalRandom))
        }
        NSLayoutConstraint.activate([
            leftText,
            rightText,
            topOrBootomText
            ])
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = .clear
    }
}
