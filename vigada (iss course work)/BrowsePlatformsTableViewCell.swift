//
//  BrowsePlatformsTableViewCell.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 10.12.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

protocol BrowsePlatformsTableViewCellTapDelegate: class {
    func platformsCollectionCellTapped(_ numberCell: Int)
}

class BrowsePlatformsTableViewCell: UITableViewCell {

    weak var delegate: BrowsePlatformsTableViewCellTapDelegate?

    private let allContainer = UIElements().containerView
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    var cellImage = [Data?]()
    var cellText = [String]()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.clipsToBounds = true

        allContainer.layer.cornerRadius = 16
        allContainer.layer.shadowColor = UIColor.VGDColor.black.cgColor
        allContainer.layer.shadowRadius = 3
        allContainer.layer.shadowOpacity = 0.4
        allContainer.layer.shadowOffset = CGSize(width: 2, height: 5)
        allContainer.layer.masksToBounds = false
        allContainer.alpha = 0.8
        allContainer.backgroundColor = UIColor.VGDColor.clear

        contentView.addSubview(allContainer)
        NSLayoutConstraint.activate([
            allContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            allContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            allContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            allContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -0),

            // тут меняем величину ячейки
            //allContainer.heightAnchor.constraint(equalTo: contentView.widthAnchor, constant: -8)
            allContainer.heightAnchor.constraint(equalToConstant: 120)
            ])

        collectionView.backgroundColor = UIColor.VGDColor.clear
        collectionView.register(BrowsePlatformsCollectionViewCell.self, forCellWithReuseIdentifier: "BrowsePlatformsCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        contentView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: allContainer.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: allContainer.trailingAnchor, constant: -0),
            collectionView.centerYAnchor.constraint(equalTo: allContainer.centerYAnchor, constant: 0),
            collectionView.heightAnchor.constraint(equalTo: allContainer.heightAnchor)
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

extension BrowsePlatformsTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSizeHeight = collectionView.frame.height / 1.15
        let cellSizeWidth = cellSizeHeight + 16
        return CGSize(width: cellSizeWidth, height: cellSizeHeight)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellImage.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrowsePlatformsCollectionViewCell", for: indexPath) as? BrowsePlatformsCollectionViewCell
        if let imageData = cellImage[indexPath.item] {
            cell?.topImage.image = UIImage(data: imageData)
        }
        let textUpp = cellText[indexPath.item].uppercased()
        cell?.title.text = textUpp
        if let cell = cell {
            return cell
        } else {
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.platformsCollectionCellTapped(indexPath.item)
    }
}

extension BrowsePlatformsTableViewCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let collectionView = scrollView as? UICollectionView {
            if let collectionViewParallax = collectionView.visibleCells as? [BrowsePlatformsCollectionViewCell] {
                for cell in collectionViewParallax {
                    guard let indexPath = collectionView.indexPath(for: cell) else {
                        return
                    }
                    guard let attributes = collectionView.layoutAttributesForItem(at: indexPath) else {
                        return
                    }
                    let cellFrame = collectionView.convert(attributes.frame, to: contentView)
                    let translationX = cellFrame.origin.x / 10
                    cell.topImage.transform = CGAffineTransform(translationX: translationX, y: 0)
                }
            }
        }
    }
}
