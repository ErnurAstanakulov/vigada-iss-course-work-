//
//  FavoritesPanelLikeButtonView.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 28.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

final class FavoritesPanelLikeButtonView: UIView {
    // MARK: - Properties
    let allContainerView = UIElements().containerView
    let containerView = UIElements().containerView
    let addLabel = UIElements().descriptionLabel
    let categoryPanelStack = UIElements().stackViewHorizontal
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.VGDColor.green

        containerView.backgroundColor = UIColor.VGDColor.white
        containerView.layer.cornerRadius = 16
        containerView.layer.masksToBounds = true

        addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: 70),
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24)
            ])

        addStackElements()

        addLabel.text = "Edit your favorite games list"
        addLabel.font = SFMono.regular.of(textStyle: .body, defaultSize: 14)
        addLabel.textColor = UIColor.VGDColor.white

        addSubview(addLabel)
        NSLayoutConstraint.activate([
            addLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            addLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            addLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            addLabel.bottomAnchor.constraint(equalTo: categoryPanelStack.topAnchor, constant: -16)
            ])
    }
    // MARK: - Set up
    private func addStackElements() {
        for index in 0..<Favorites.segmentIcons.data.count {
            let colors = UIElements().favoritesColors
            let stackLabel = UIElements().descriptionLabel
            let stackIcon = UIElements().imageView
            let verticalStack = UIElements().stackViewVertical
            if index == Favorites.segmentIcons.data.count - 1 {
                stackLabel.text = "Remove"
            } else {
                stackLabel.text = Favorites.segmentCells.data[index]
            }

            stackLabel.font = SFMono.regular.of(textStyle: .body, defaultSize: 11)
            stackIcon.image = UIImage(named: Favorites.segmentIcons.data[index])?.tinted(with: colors[index])
            verticalStack.addArrangedSubview(stackIcon)
            verticalStack.addArrangedSubview(stackLabel)
            categoryPanelStack.addArrangedSubview(verticalStack)

            containerView.addSubview(categoryPanelStack)
            NSLayoutConstraint.activate([
                categoryPanelStack.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 0),
                categoryPanelStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 32),
                categoryPanelStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -32),
                categoryPanelStack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0)
                ])
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
