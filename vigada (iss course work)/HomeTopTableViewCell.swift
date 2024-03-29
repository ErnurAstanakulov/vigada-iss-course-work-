//
//  HomeTopTableViewCell.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 06.12.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

class HomeTopTableViewCell: UITableViewCell {

    private let allContainer = UIElements().containerView
    private let imageContainer = UIElements().containerView
    private let all1Container = UIElements().containerView
    private let all2Container = UIElements().containerView

    private let maskForImage = AngularWindowView()

    let topImage = UIElements().imageView
    let title = UIElements().titleLabel

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.clipsToBounds = true

        allContainer.layer.cornerRadius = 16
        allContainer.layer.shadowColor = UIColor.VGDColor.black.cgColor
        allContainer.layer.shadowRadius = 3
        allContainer.layer.shadowOpacity = 0.4
        allContainer.layer.shadowOffset = CGSize(width: 2, height: 5)
        allContainer.layer.masksToBounds = false
        allContainer.backgroundColor = UIColor.VGDColor.clear

        contentView.addSubview(allContainer)
        NSLayoutConstraint.activate([
            allContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            allContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            allContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            allContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            allContainer.heightAnchor.constraint(equalToConstant: 360)
            ])

        imageMask()

        title.textColor = UIColor.VGDColor.white
        title.text = " CYKA BLYAT  "
        title.textAlignment = .right
        title.numberOfLines = 0
        let randomInt = Int.random(in: 18...30)
        title.font = SFMono.bold.of(size: CGFloat(randomInt))
        title.backgroundColor = UIColor.VGDColor.black
        title.alpha = 0.8
        contentView.addSubview(title)
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(greaterThanOrEqualTo: topImage.leadingAnchor, constant: 0),
            title.trailingAnchor.constraint(equalTo: topImage.trailingAnchor, constant: -16),
            title.bottomAnchor.constraint(equalTo: topImage.bottomAnchor, constant: -80)
            ])
    }

    func imageMask() {
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
