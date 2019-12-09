//
//  GDScreenshotsTableViewCell.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 30.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

class GDScreenshotsTableViewCell: UITableViewCell {

    let screenshotsContainer = UIElements().containerView
    let screenshotCell1 = UIElements().imageView
    let screenshotCell2 = UIElements().imageView
    let screenshotCell3 = UIElements().imageView
    let screenshotCell4 = UIElements().imageView
    let screenshotQuantity = UIElements().descriptionLabel
    let tintCellContainer = UIElements().containerView
    let screenshotsStack = UIElements().stackViewHorizontal
    let cell1 = UIElements().containerView
    let cell2 = UIElements().containerView
    let cell3 = UIElements().containerView
    let cell4 = UIElements().containerView
    let spacing: CGFloat = 4

    lazy var stackView: UIStackView = {
        let stackv = UIStackView(arrangedSubviews: [screenshotCell1, screenshotCell2, screenshotCell3, screenshotCell4])
        stackv.translatesAutoresizingMaskIntoConstraints = false
        stackv.axis = .horizontal
        stackv.spacing = spacing
        stackv.distribution = .fillEqually
        return stackv
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        cell1.backgroundColor = UIColor.VGDColor.orange
        cell2.backgroundColor = UIColor.VGDColor.yellow
        cell3.backgroundColor = UIColor.VGDColor.green
        cell4.backgroundColor = UIColor.VGDColor.pink
        screenshotCell1.image = UIImage(named: "placeholder1")
        screenshotCell2.image = UIImage(named: "placeholder2")
        screenshotCell3.image = UIImage(named: "placeholder3")
        screenshotCell4.image = UIImage(named: "placeholder4")
        screenshotCell1.contentMode = .scaleAspectFill
        screenshotCell2.contentMode = .scaleAspectFill
        screenshotCell3.contentMode = .scaleAspectFill
        screenshotCell4.contentMode = .scaleAspectFill

        var stackCellHeight = (contentView.frame.width / 4) - (spacing * 4)
        stackCellHeight = 64
        stackView.backgroundColor = UIColor.VGDColor.black
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stackView.heightAnchor.constraint(equalToConstant: stackCellHeight)
            ])

        screenshotsContainer.backgroundColor = UIColor.VGDColor.white
        contentView.addSubview(screenshotsContainer)
        NSLayoutConstraint.activate([
            screenshotsContainer.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            screenshotsContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            screenshotsContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            screenshotsContainer.heightAnchor.constraint(equalToConstant: 0),
            screenshotsContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
            ])

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        accessoryType = .none
    }

}
