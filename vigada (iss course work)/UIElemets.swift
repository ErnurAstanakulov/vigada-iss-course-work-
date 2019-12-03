//
//  UIElemets.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 23.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

final class UIElements {
    // Коллекция базовых элементов UI
    let favoritesColors = [UIColor.VGDColor.green, UIColor.VGDColor.yellow, UIColor.VGDColor.blue, UIColor.VGDColor.orange]

    let button: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = NewYork.black.of(size: 20)
        button.setTitle("Next", for: .normal)
        button.setTitleColor(UIColor.VGDColor.white, for: .normal)
        button.backgroundColor = UIColor.VGDColor.black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 2.0
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 2, height: 1)
        button.layer.masksToBounds = false
        return button
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = NewYork.regular.of(textStyle: .largeTitle, defaultSize: 34)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 2.0
        label.layer.shadowOpacity = 0.4
        label.layer.shadowOffset = CGSize(width: 2, height: 1)
        label.layer.masksToBounds = false
        return label
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = SFCompactText.regular.of(textStyle: .body, defaultSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let monoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = SFMono.regular.of(textStyle: .body, defaultSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    let settingButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = NewYork.regular.of(size: 18)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 0
        button.setTitleColor(UIColor.VGDColor.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let stackViewVertical: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution  = .equalSpacing
        stackView.alignment = .center
        stackView.spacing   = 4.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    let stackViewHorizontal: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution  = .equalSpacing
        stackView.alignment = .center
        stackView.spacing   = 4.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

}

extension UIImage {
    func tinted(with color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        color.set()
        withRenderingMode(.alwaysTemplate)
            .draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
