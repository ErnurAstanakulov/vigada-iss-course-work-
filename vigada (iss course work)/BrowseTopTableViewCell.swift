//
//  BrowseTopTableViewCell.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 09.12.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

class BrowseTopTableviewCell: UITableViewCell {

    weak var delegate: BrowseTopTableViewCellTapDelegate?

    private let allContainer = UIElements().containerView
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 24, right: 0)
        return collectionView
    }()

    var cellImage = [Data?]()
    var cellText = [String]()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.clipsToBounds = true

        allContainer.backgroundColor = UIColor.VGDColor.clear
        contentView.addSubview(allContainer)
        NSLayoutConstraint.activate([
            allContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            allContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -0),
            allContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            allContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -0),

            // тут меняем величину ячейки
            allContainer.heightAnchor.constraint(equalTo: contentView.widthAnchor, constant: -0)
            ])

        collectionView.backgroundColor = UIColor.VGDColor.clear
        collectionView.register(BrowseTopCollectionViewCell.self, forCellWithReuseIdentifier: "BrowseTopCollectionViewCell")
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

extension BrowseTopTableviewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSizeHeight = collectionView.frame.height / 1.15
        let cellSizeWidth = cellSizeHeight + 16
        return CGSize(width: cellSizeWidth, height: cellSizeHeight)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellImage.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrowseTopCollectionViewCell", for: indexPath) as? BrowseTopCollectionViewCell
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.topCollectionCellTapped(indexPath.item)
    }
}
