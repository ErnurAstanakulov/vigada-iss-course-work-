//
//  ScreenshotsGalleryCell.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 02.12.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

final class ScreenshotsCollectionViewCell: UICollectionViewCell {

    let screenshot: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.VGDColor.black.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        screenshot.layer.cornerRadius = 0
        screenshot.clipsToBounds = true
        contentView.addSubview(screenshot)
        NSLayoutConstraint.activate([
            screenshot.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            screenshot.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -0),
            screenshot.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            screenshot.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -0)
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
