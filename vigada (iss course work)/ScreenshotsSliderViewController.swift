//
//  ScreenshotsSliderViewController.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 03.12.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

class ScreenshotsSliderViewController: UIViewController {
    // MARK: - Properties
    private let screenshotSliderCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = UIColor.VGDColor.black
        collection.isScrollEnabled = true
        return collection
    }()

    private let closeControllerButton = UIElements().imageView

    private let countCells: CGFloat = 1
    var indexPath: IndexPath?
    var screenshotsArraySlider: [Data]?
    var isInternetSS = true
    // MARK: UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.VGDColor.black

        setupCollectionView()
    }

    // MARK: - Set up
    private func setupCollectionView() {
        screenshotSliderCollectionView.dataSource = self
        screenshotSliderCollectionView.delegate = self
        screenshotSliderCollectionView.register(ScreenshotsSlideCell.self, forCellWithReuseIdentifier: "ScreenshotsSlideCell")
        screenshotSliderCollectionView.isPagingEnabled = true
        screenshotSliderCollectionView.isUserInteractionEnabled = true
        screenshotSliderCollectionView.contentInsetAdjustmentBehavior = .never
        screenshotSliderCollectionView.clipsToBounds = true

        view.addSubview(screenshotSliderCollectionView)
        NSLayoutConstraint.activate([
            screenshotSliderCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            screenshotSliderCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            screenshotSliderCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            screenshotSliderCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
            ])

        screenshotSliderCollectionView.performBatchUpdates(nil) { _ in
            if let indexPath = self.indexPath {
                self.screenshotSliderCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }
    }

    func setupCloseControllerButton() {
        if !isInternetSS {
            closeControllerButton.image = UIImage(named: "close")?.tinted(with: UIColor.VGDColor.white)
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
        self.dismiss(animated: false, completion: nil)
    }

}
// MARK: - Extensions
extension ScreenshotsSliderViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return screenshotsArraySlider?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScreenshotsSlideCell", for: indexPath) as? ScreenshotsSlideCell
        guard let imageData = screenshotsArraySlider?[indexPath.item] else {
            fatalError("плейсхолдер покажи!")
        }
        cell?.screenshotSlideImageView.image = UIImage(data: imageData)
        cell?.layer.cornerRadius = 0
        if let cell = cell {
            return cell
        } else {
            fatalError("Что-то не так с ScreenshotsSlideCell")
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let frameCollectionView = collectionView.frame
        let widthCell = frameCollectionView.width - 10
        let heightCell = frameCollectionView.height
        return CGSize(width: widthCell, height: heightCell)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        screenshotSliderCollectionView.collectionViewLayout.invalidateLayout()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        screenshotSliderCollectionView.collectionViewLayout.invalidateLayout()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        let offset = CGPoint(x: self.screenshotSliderCollectionView.center.x + self.screenshotSliderCollectionView.contentOffset.x,
                                        y: self.screenshotSliderCollectionView.center.y + self.screenshotSliderCollectionView.contentOffset.y)

        let width = screenshotSliderCollectionView.bounds.size.width

        let index = round(offset.x / width)
        let newOffset = CGPoint(x: index * size.width, y: offset.y)
        screenshotSliderCollectionView.setContentOffset(newOffset, animated: false)

        guard let indexPath = screenshotSliderCollectionView.indexPathForItem(at: offset) else {
            return
        }
        screenshotSliderCollectionView.performBatchUpdates(nil) { _ in
            self.screenshotSliderCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }

        coordinator.animate(alongsideTransition: { _ in
            self.screenshotSliderCollectionView.reloadData()
            self.screenshotSliderCollectionView.setContentOffset(newOffset, animated: true)
        }, completion: nil)
    }
}

extension ScreenshotsSliderViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.tintColor = UIColor.VGDColor.white
        allRotateStateForDevice()
        setupCloseControllerButton()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
        rotateToPotraitScapeDevice()
    }

    private func allRotateStateForDevice() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.myOrientation = .all
    }

    private func rotateToPotraitScapeDevice() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.myOrientation = .portrait
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        UIView.setAnimationsEnabled(true)
    }
}
