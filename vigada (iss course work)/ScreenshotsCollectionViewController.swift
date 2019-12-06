//
//  ScreenshotsCollectionViewController.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 02.12.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit
class ScreenshotsCollectionViewController: UIViewController {
    // MARK: - Properties
    private let screenshotsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = UIColor.VGDColor.black
        collection.isScrollEnabled = true
        return collection
    }()

    private let closeControllerButton = UIElements().imageView

    private let countCells: CGFloat = 3
    private let spacingSize: CGFloat = 8

    var gameScreenshotsArray: [Data]?
    var isInternetSG = true

    // MARK: UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.VGDColor.black

        setupCollection()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.tintColor = UIColor.VGDColor.white

        setupCloseControllerButton()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.tintColor = UIColor.VGDColor.blue
    }

    // MARK: - Set up
    private func setupCollection() {
        screenshotsCollectionView.delegate = self
        screenshotsCollectionView.dataSource = self
        screenshotsCollectionView.register(ScreenshotsCollectionViewCell.self, forCellWithReuseIdentifier: "ScreenshotsCollectionViewCell")

        view.addSubview(screenshotsCollectionView)
        NSLayoutConstraint.activate([
            screenshotsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            screenshotsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            screenshotsCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            screenshotsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
            ])
    }

    func setupCloseControllerButton() {
        if !isInternetSG {
            closeControllerButton.image = UIImage(named: "close")
            view.addSubview(closeControllerButton)
            NSLayoutConstraint.activate([
                closeControllerButton.widthAnchor.constraint(equalToConstant: 24),
                closeControllerButton.heightAnchor.constraint(equalToConstant: 24),
                closeControllerButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
                closeControllerButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
                ])
            closeControllerButton.isUserInteractionEnabled = true
            let gestureTap = UITapGestureRecognizer(target: self, action: #selector(self.closeTapped(_:)))
            closeControllerButton.addGestureRecognizer(gestureTap)
        }
    }

    @objc func closeTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }

}
// MARK: - Extensions
extension ScreenshotsCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameScreenshotsArray?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = screenshotsCollectionView.dequeueReusableCell(withReuseIdentifier: "ScreenshotsCollectionViewCell", for: indexPath) as? ScreenshotsCollectionViewCell
        guard let imageData = gameScreenshotsArray?[indexPath.item] else {
            fatalError("плейсхолдер покажи!")
        }
        cell?.screenshot.image = UIImage(data: imageData)
        if let cell = cell {
            return cell
        } else {
            fatalError("Поломалося скриншотов коллекция-то. Бяда")
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let frameCV = collectionView.frame
        let widthCell = frameCV.width / countCells
        let heightCell = widthCell
        let spacing = (countCells + 1) * spacingSize / countCells
        return CGSize(width: widthCell - spacing, height: heightCell - spacingSize * 2)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextViewController = ScreenshotsSliderViewController()
        nextViewController.screenshotsArraySlider = self.gameScreenshotsArray
        nextViewController.indexPath = indexPath
        if let navigator = navigationController {
            nextViewController.isInternetSS = true
            navigator.pushViewController(nextViewController, animated: true)
        } else {
            nextViewController.isInternetSS = false
            nextViewController.modalTransitionStyle = .crossDissolve
            self.present(nextViewController, animated: false, completion: nil)
        }
    }
}
