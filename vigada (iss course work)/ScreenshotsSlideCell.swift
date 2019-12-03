//
//  ScreenshotsSlideCell.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 03.12.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

class ScreenshotsSlideCell: UICollectionViewCell, UIScrollViewDelegate {

    let screenshotSlideImageView = UIElements().imageView

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.preservesSuperviewLayoutMargins = false
        self.layoutMargins = .zero

        contentView.backgroundColor = UIColor.VGDColor.black

        screenshotSlideImageView.backgroundColor = UIColor.VGDColor.black
        screenshotSlideImageView.contentMode = .scaleAspectFit

        addSubview(screenshotSlideImageView)
        NSLayoutConstraint.activate([
            screenshotSlideImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            screenshotSlideImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -0),
            screenshotSlideImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            screenshotSlideImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -0)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = .clear
    }
}
