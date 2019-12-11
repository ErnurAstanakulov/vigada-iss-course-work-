//
//  HomeSecondTableViewCell.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 06.12.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

class HomeSecondTableViewCell: UITableViewCell {

    private let allContainer = UIElements().containerView
    private let imageContainer = UIElements().containerView
    private let all1Container = UIElements().containerView
    private let all2Container = UIElements().containerView
    let topImage = UIElements().imageView
    let title = UIElements().titleLabel

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        allContainer.backgroundColor = UIColor.VGDColor.clear

        contentView.addSubview(allContainer)
        NSLayoutConstraint.activate([
            allContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            allContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            allContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            allContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            allContainer.heightAnchor.constraint(equalToConstant: 128)
            ])

        topImage.image = UIImage(named: "placeholder2")
        topImage.contentMode = .scaleAspectFill
        allContainer.addSubview(topImage)
        NSLayoutConstraint.activate([
            topImage.leadingAnchor.constraint(equalTo: allContainer.leadingAnchor, constant: 32),
            topImage.trailingAnchor.constraint(equalTo: allContainer.trailingAnchor, constant: -32),
            topImage.topAnchor.constraint(equalTo: allContainer.topAnchor, constant: 8),
            topImage.bottomAnchor.constraint(equalTo: allContainer.bottomAnchor, constant: -8)
            ])

        title.textColor = UIColor.VGDColor.white
        title.text = "  CYKA BLYAT "
        title.textAlignment = .left
        title.font = SFMono.bold.of(size: 24)
        title.numberOfLines = 0
        title.backgroundColor = UIColor.VGDColor.black
        title.alpha = 0.8
        allContainer.addSubview(title)
        randomLeftOrRightTitle()
    }
    func randomLeftOrRightTitle() {
        let leftOrRight = Bool.random()
        var randomConstraint = NSLayoutConstraint()
        var rangeConstraint = NSLayoutConstraint()
        if leftOrRight {
            randomConstraint = title.leadingAnchor.constraint(equalTo: allContainer.leadingAnchor, constant: 0)
            rangeConstraint = title.trailingAnchor.constraint(lessThanOrEqualTo: allContainer.trailingAnchor, constant: 0)
        } else {
            rangeConstraint = title.leadingAnchor.constraint(greaterThanOrEqualTo: allContainer.leadingAnchor, constant: 0)
            randomConstraint = title.trailingAnchor.constraint(equalTo: allContainer.trailingAnchor, constant: -0)
        }
        let bottomRandom = Int.random(in: 16...40)
        NSLayoutConstraint.activate([
            randomConstraint,
            rangeConstraint,
            title.bottomAnchor.constraint(equalTo: allContainer.bottomAnchor, constant: -CGFloat(bottomRandom))
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
