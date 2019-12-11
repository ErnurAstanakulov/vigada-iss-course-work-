//
//  BrowseTopCollectionViewCell.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 09.12.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

class BrowseTopCollectionViewCell: UICollectionViewCell {
    private let allContainer = UIElements().containerView
    private let imageContainer = UIElements().containerView
    let topImage = UIElements().imageView
    let title = UIElements().titleLabel

    //private let maskForImage = AngularWindowView()
    private let maskForImage = TileWindowView()
    //private let maskForImage = TVWindowView()
    let imageTop = UIElements().containerView
    let rectangle2 = UIElements().containerView

    override init(frame: CGRect) {
        super.init(frame: .zero)

        contentView.addSubview(allContainer)
        NSLayoutConstraint.activate([
            allContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            allContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            allContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            allContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -0)
            ])

        let angle: [CGFloat] = [0, 90, 180, 270]
        guard let randomAngle: CGFloat = angle.randomElement() else {
            return
        }
        maskForImage.rotate(degrees: randomAngle)
        maskForImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(maskForImage)
        NSLayoutConstraint.activate([
            maskForImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0),
            maskForImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -0),
            maskForImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -16),
            maskForImage.heightAnchor.constraint(equalTo: maskForImage.widthAnchor, constant: 0)
            ])

        topImage.rotate(degrees: -randomAngle)
        topImage.image = UIImage(named: "placeholder3")
        topImage.contentMode = .scaleAspectFill
        maskForImage.addSubview(topImage)
        NSLayoutConstraint.activate([
            topImage.leadingAnchor.constraint(equalTo: allContainer.leadingAnchor, constant: -8),
            topImage.trailingAnchor.constraint(equalTo: allContainer.trailingAnchor, constant: 8),
            topImage.topAnchor.constraint(equalTo: allContainer.topAnchor, constant: -8),
            topImage.bottomAnchor.constraint(equalTo: allContainer.bottomAnchor, constant: 8)
            ])

        title.textColor = UIColor.VGDColor.white
        title.text = " CYKA BLYAT  "
        title.textAlignment = .right
        title.numberOfLines = 0
        title.alpha = 0.8
        let randomInt = Int.random(in: 18...48)
        title.font = SFMono.bold.of(size: CGFloat(randomInt))
        title.backgroundColor = UIColor.VGDColor.black
        contentView.addSubview(title)
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
