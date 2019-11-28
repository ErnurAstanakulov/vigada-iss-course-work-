//
//  FavoritesPanelLikeButtonView.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 28.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

class FavoritesPanelLikeButtonView: UIView {

    let containerView = UIElements().containerView
    let containerView2 = UIElements().containerView
    let addLabel = UIElements().descriptionLabel

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.translatesAutoresizingMaskIntoConstraints = false

        self.backgroundColor = UIColor.VGDColor.green

        containerView.backgroundColor = UIColor.VGDColor.blue

        containerView2.backgroundColor = UIColor.VGDColor.pink

        addLabel.text = "Add to favorites. Or remove from there"
        addLabel.font = SFMono.regular.of(textStyle: .body, defaultSize: 14)
        addLabel.textColor = UIColor.VGDColor.white

        addSubview(addLabel)
        NSLayoutConstraint.activate([
            addLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            addLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            addLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            addLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32)
            ])

//        containerView2.layer.cornerRadius = 8
//        containerView2.layer.masksToBounds = true
//        containerView2.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]

//        addSubview(containerView)
//        NSLayoutConstraint.activate([
//            containerView.heightAnchor.constraint(equalToConstant: 100),
//            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
//            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
//            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -0),
//            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
//            ])
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
