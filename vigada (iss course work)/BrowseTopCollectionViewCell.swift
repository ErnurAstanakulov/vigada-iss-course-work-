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

    let maskForImage = AngularWindowView()
    //let maskForImage = TVWindowView()
    let imageTop = UIElements().containerView
    let rectangle2 = UIElements().containerView

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

        let angle: [CGFloat] = [0, 90, 180, 270]
        let randomAngle = Int.random(in: 0...3)
        maskForImage.rotate(degrees: angle[randomAngle])
        maskForImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(maskForImage)
        NSLayoutConstraint.activate([
            maskForImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0),
            maskForImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -0),
            maskForImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -16),
            maskForImage.heightAnchor.constraint(equalTo: maskForImage.widthAnchor, constant: 0)
            ])

        imageTop.backgroundColor = .red //UIColor.VGDColor.white
        maskForImage.addSubview(imageTop)
        NSLayoutConstraint.activate([
            imageTop.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0),
            imageTop.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -0),
            imageTop.widthAnchor.constraint(equalTo: maskForImage.widthAnchor),
            imageTop.heightAnchor.constraint(equalTo: maskForImage.heightAnchor)
            ])

        topImage.rotate(degrees: -angle[randomAngle])
        topImage.image = UIImage(named: "placeholder4")
        topImage.contentMode = .scaleAspectFill
        imageTop.addSubview(topImage)
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
        let randomInt = Int.random(in: 18...36)
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
            leftText = title.leadingAnchor.constraint(equalTo: imageTop.leadingAnchor, constant: -8)
            rightText = title.trailingAnchor.constraint(lessThanOrEqualTo: imageTop.trailingAnchor, constant: 0)
        } else {
            rightText = title.leadingAnchor.constraint(greaterThanOrEqualTo: imageTop.leadingAnchor, constant: 0)
            leftText = title.trailingAnchor.constraint(equalTo: imageTop.trailingAnchor, constant: 8)
        }
        let verticalRandom = Int.random(in: 16...40)
        if topOrBottom {
            topOrBootomText = title.topAnchor.constraint(equalTo: imageTop.topAnchor, constant: CGFloat(verticalRandom))
        } else {
            topOrBootomText = title.bottomAnchor.constraint(equalTo: imageTop.bottomAnchor, constant: -CGFloat(verticalRandom))
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
