//
//  OnBoardViewController.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 20.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

class OnBoardViewController: UIViewController, UIScrollViewDelegate {
    // MARK: - Properties
    private let titlesArray = ["Discover the world \nof video games",
                  "The largest open \nvideo games database",
                  "Add games to favorites \n& a wish list",
                  "Follow the release \nof new games"]

    private let descriptionArray = ["Since 1947 and forever \nMillions of players around the world",
                       "More than 350,000 games in the database",
                       "Use the full power of the search \nKeep your favorites online",
                       "See the information on the release screen"]
    private let imagesArray = ["onBoardImagesA", "onBoardImagesB", "onBoardImagesC", "onBoardImagesD"]

    private let nextButton = UIElements().button
    private let scrollView = UIElements().scrollView

    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()

    private var scrollWidth: CGFloat = 0.0
    private var scrollHeight: CGFloat = 0.0

    override func viewDidLayoutSubviews() {
        scrollWidth = scrollView.frame.size.width
        scrollHeight = scrollView.frame.size.height
    }
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.VGDColor.white

        setupScrollView()

        setupNextButton()

        setupPageControl()

        var frame = CGRect(x: 0, y: 0, width: 0, height: 0)

        for index in 0..<titlesArray.count {
            frame.origin.x = scrollWidth * CGFloat(index)
            frame.size = CGSize(width: scrollWidth, height: scrollHeight)

            setupOnBoardSlide(frame: frame, index: index)
        }

        scrollView.contentSize = CGSize(width: scrollWidth * CGFloat(titlesArray.count), height: scrollHeight)

        pageControl.numberOfPages = titlesArray.count
        pageControl.currentPage = 0
    }

    // MARK: - Set up
    private func setupOnBoardSlide(frame: CGRect, index: Int) {
        let slide = UIView(frame: frame)

        scrollView.addSubview(slide)

        let title = setTitleLabel()
        let description = setDescriptionLabel()
        let imageView = setImageView()

        title.text = titlesArray[index]
        description.text = descriptionArray[index]
        imageView.image = UIImage(named: imagesArray[index])

        slide.addSubview(title)
        slide.addSubview(description)
        slide.addSubview(imageView)

        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: slide.leadingAnchor, constant: 40),
            title.trailingAnchor.constraint(equalTo: slide.trailingAnchor, constant: -40),
            title.topAnchor.constraint(lessThanOrEqualTo: slide.topAnchor, constant: 104),
            title.topAnchor.constraint(greaterThanOrEqualTo: slide.topAnchor, constant: 40),
            title.centerXAnchor.constraint(equalTo: slide.centerXAnchor, constant: 0)
            ])

        NSLayoutConstraint.activate([
            description.leadingAnchor.constraint(equalTo: slide.leadingAnchor, constant: 56),
            description.trailingAnchor.constraint(equalTo: slide.trailingAnchor, constant: -56),
            description.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
            description.centerXAnchor.constraint(equalTo: slide.centerXAnchor, constant: 0)
            ])

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: slide.leadingAnchor, constant: 56),
            imageView.trailingAnchor.constraint(equalTo: slide.trailingAnchor, constant: -56),
            imageView.topAnchor.constraint(lessThanOrEqualTo: description.bottomAnchor, constant: 128),
            imageView.topAnchor.constraint(greaterThanOrEqualTo: description.bottomAnchor, constant: 40),
            imageView.centerXAnchor.constraint(equalTo: slide.centerXAnchor, constant: 0),
            imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 100),
            imageView.bottomAnchor.constraint(equalTo: slide.bottomAnchor, constant: -16)
            ])
    }

    private func setTitleLabel() -> UILabel {
        let title = UIElements().titleLabel
        return title
    }

    private func setDescriptionLabel() -> UILabel {
        let description = UIElements().descriptionLabel
        return description
    }

    private func setImageView() -> UIImageView {
        let imageView = UIElements().imageView
        return imageView
    }

    private func setupScrollView() {
        self.view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -176)
            ])

        self.view.layoutIfNeeded()

        self.scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
    }

    private func setupPageControl() {
        self.pageControl.numberOfPages = titlesArray.count
        self.pageControl.currentPage = 0
        self.pageControl.pageIndicatorTintColor = UIColor.VGDColor.lightGray
        self.pageControl.currentPageIndicatorTintColor = UIColor.VGDColor.redmy

        self.view.addSubview(pageControl)

        NSLayoutConstraint.activate([
            pageControl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 56),
            pageControl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -56),
            pageControl.topAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: 8),
            pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0)
            ])

    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setIndiactorForCurrentPage()
    }

    private func setIndiactorForCurrentPage() {
        let page = (scrollView.contentOffset.x)/scrollWidth
        pageControl.currentPage = Int(page)
        // Кнопка появляется на последнем слайде
        if Int(page) == titlesArray.count - 1 {
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
                self.nextButton.alpha = 1.0
            })
        } else {
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
                self.nextButton.alpha = 0.0
            })
        }
    }

    private func setupNextButton() {
        self.view.addSubview(nextButton)
        nextButton.alpha = 0
        NSLayoutConstraint.activate([
            nextButton.widthAnchor.constraint(equalToConstant: 200),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            nextButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            nextButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -64)
            ])
        nextButton.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
    }

    // Устанавливаем значение просмотренного приветствия
    @objc func buttonClicked() {
        let newViewController = LoaderViewController()
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
        UserDefaults.standard.set(true, forKey: "isOnBoardSeen")
    }

}
