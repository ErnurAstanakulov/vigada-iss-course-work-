//
//  ScreenshotsCollectionViewCell.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 01.12.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

class ScreenshotsCollectionViewCell: UICollectionViewCell {

    let screenshot = UIElements().imageView

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        screenshot.contentMode = .scaleAspectFill
        contentView.addSubview(screenshot)
        screenshot.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            screenshot.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            screenshot.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            screenshot.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -0),
            screenshot.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -0)
            ])
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        screenshot.image = nil
        backgroundColor = .white
    }
}
