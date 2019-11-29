//
//  GameDetailsViewController.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 21.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

class GameDetailsViewController: UIViewController {
    // MARK: - Properties
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let reuseId = "UITableViewCellreuseId"
    private let favoritesPanelLikeButtonView = FavoritesPanelLikeButtonView()
    private let favoritesSelectActionView = FavoritesSelectActionView()

    private let containerViewForTable = UIElements().containerView
    private let viewWithShadowAndCorners = UIElements().containerView

    var tableviewContainerShiftConstraint = NSLayoutConstraint()
    var favorSelectActionViewHeightConstraint = NSLayoutConstraint()
    var favorSelectActionViewWidthConstraint = NSLayoutConstraint()
    // MARK: UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Game Title"
        view.backgroundColor = UIColor.VGDColor.white

        self.tabBarController?.tabBar.isHidden = true

        setupScreen()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.tableViewContainerUp()
        }

        for index in 0..<favoritesPanelLikeButtonView.categoryPanelStack.arrangedSubviews.count {
            let gestureTap = UITapGestureRecognizer(target: self, action: #selector(self.stackViewTapped(_:)))
            favoritesPanelLikeButtonView.categoryPanelStack.arrangedSubviews[index].addGestureRecognizer(gestureTap)
            favoritesPanelLikeButtonView.categoryPanelStack.arrangedSubviews[index].tag = index
        }

        // TODO: когда буду показывать инфу, то если игра уже в фаворитсах - показать иконку какую надо, если нет её там, то сердечке в круге

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false

    }
    // MARK: - Action
    @objc func stackViewTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        if let stackTag = gestureRecognizer.view?.tag {
            // все делаем черными, потом раскрашиваем какой-то один
            stackChangeColor(numberElement: 0)
            stackChangeColor(numberElement: 1)
            stackChangeColor(numberElement: 2)
            stackChangeColor(numberElement: 3)
            stackChangeColor(numberElement: stackTag, color: true)
            let icon = Favorites.segmentIcons.data[stackTag]
            let color = UIElements().favoritesColors

            favoritesSelectActionView.favoritesIcon.image = UIImage(named: icon)?.tinted(with: UIColor.VGDColor.white)
            favoritesSelectActionView.backgroundColor = color[stackTag]
            tableviewContainerDown()

            self.favorSelectActionViewHeightConstraint.constant = 64
            self.favorSelectActionViewWidthConstraint.constant = 64
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
                self.favoritesSelectActionView.alpha = 0.5
            }, completion: { _ in
                self.favoritesSelectActionViewHide()
            })
        }
    }
    @objc func favoritesSelectActionViewHide() {
        self.favorSelectActionViewHeightConstraint.constant = 104
        self.favorSelectActionViewWidthConstraint.constant = 104
        UIView.animate(withDuration: 0.6, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
            self.favoritesSelectActionView.alpha = 0
        }, completion: nil)
    }

    private func tableViewContainerUp() {
        let height = self.favoritesPanelLikeButtonView.frame.size.height
        self.tableviewContainerShiftConstraint.constant = -(height - 28)
        UIView.animate(withDuration: 0.9, delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    private func tableviewContainerDown() {
        self.tableviewContainerShiftConstraint.constant = -0
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    private func stackChangeColor(numberElement: Int, color: Bool = false) {
        let labels = Favorites.segmentCells.data
        let icons = Favorites.segmentIcons.data
        let colors = UIElements().favoritesColors
        let elementLabel = UIElements().descriptionLabel
        let elementStack = UIElements().stackViewVertical
        let elementIcon = UIElements().imageView
        if numberElement == Favorites.segmentCells.data.count - 1 {
            elementLabel.text = "Remove"
        } else {
            elementLabel.text = labels[numberElement]
        }
        if color {
            elementLabel.textColor = colors[numberElement]
        } else {
            elementLabel.textColor = UIColor.VGDColor.black
        }
        elementLabel.font = SFMono.regular.of(textStyle: .body, defaultSize: 11)
        let elementIconImage = UIImage(named: icons[numberElement])
        elementIcon.image = elementIconImage?.tinted(with: colors[numberElement])
        elementStack.addArrangedSubview(elementIcon)
        elementStack.addArrangedSubview(elementLabel)
        elementStack.translatesAutoresizingMaskIntoConstraints = false
        favoritesPanelLikeButtonView.categoryPanelStack.arrangedSubviews[numberElement].addSubview(elementStack)
    }

    // MARK: - Set up
    private func setupScreen() {
        view.addSubview(favoritesPanelLikeButtonView)
        NSLayoutConstraint.activate([
            favoritesPanelLikeButtonView.heightAnchor.constraint(equalToConstant: 152),
            favoritesPanelLikeButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            favoritesPanelLikeButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
            favoritesPanelLikeButtonView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -0)
            ])

        view.addSubview(containerViewForTable)
        tableviewContainerShiftConstraint = containerViewForTable.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        NSLayoutConstraint.activate([
            containerViewForTable.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 0),
            containerViewForTable.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0),
            containerViewForTable.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            tableviewContainerShiftConstraint
            ])

        setupTableView()

        favoritesSelectActionView.alpha = 0
        containerViewForTable.addSubview(favoritesSelectActionView)
        favorSelectActionViewHeightConstraint = favoritesSelectActionView.heightAnchor.constraint(equalToConstant: 88)
        favorSelectActionViewWidthConstraint = favoritesSelectActionView.widthAnchor.constraint(equalToConstant: 88)
        NSLayoutConstraint.activate([
            favoritesSelectActionView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            favoritesSelectActionView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            favorSelectActionViewHeightConstraint,
            favorSelectActionViewWidthConstraint
            ])
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: "SearchResultTableViewCell")
        tableView.register(SearchRecentTableViewCell.self, forCellReuseIdentifier: "SearchRecentTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = UIColor.VGDColor.clear
        tableView.backgroundColor = .white
        tableView.contentInsetAdjustmentBehavior = .never

        viewWithShadowAndCorners.backgroundColor = UIColor.VGDColor.white

        let window = UIApplication.shared.windows[0]
        let safeFrame = window.safeAreaLayoutGuide.layoutFrame
        var bottomSafeAreaHeight = window.frame.maxY - safeFrame.maxY

        viewWithShadowAndCorners.layer.cornerRadius = bottomSafeAreaHeight / 2
        if bottomSafeAreaHeight == 0 {
            bottomSafeAreaHeight = 32
            viewWithShadowAndCorners.layer.cornerRadius = 0
        }
        viewWithShadowAndCorners.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        viewWithShadowAndCorners.layer.shadowColor = UIColor.black.cgColor
        viewWithShadowAndCorners.layer.shadowRadius = 2.0
        viewWithShadowAndCorners.layer.shadowOpacity = 0.4
        viewWithShadowAndCorners.layer.shadowOffset = CGSize(width: 0, height: 3)
        viewWithShadowAndCorners.layer.masksToBounds = false

        containerViewForTable.addSubview(viewWithShadowAndCorners)
        NSLayoutConstraint.activate([
            viewWithShadowAndCorners.heightAnchor.constraint(equalToConstant: bottomSafeAreaHeight),
            viewWithShadowAndCorners.centerXAnchor.constraint(equalTo: containerViewForTable.centerXAnchor),
            viewWithShadowAndCorners.leadingAnchor.constraint(equalTo: containerViewForTable.leadingAnchor, constant: 0),
            viewWithShadowAndCorners.trailingAnchor.constraint(equalTo: containerViewForTable.trailingAnchor, constant: -0),
            viewWithShadowAndCorners.bottomAnchor.constraint(equalTo: containerViewForTable.bottomAnchor, constant: -0)
            ])

        containerViewForTable.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: containerViewForTable.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: containerViewForTable.trailingAnchor, constant: -0),
            tableView.topAnchor.constraint(equalTo: containerViewForTable.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: viewWithShadowAndCorners.topAnchor, constant: 1)
            ])
    }

}

// MARK: - Extensions
extension GameDetailsViewController: UITableViewDataSource, UITableViewDelegate {

    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as? SearchResultTableViewCell
        cell?.settingView.settingLabel.text = "test"
        cell?.selectionStyle = .none
        if let cell = cell {
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
            cell.textLabel?.text = "Broke 'Settings' table row"
            return cell
        }
    }

    // MARK: - UITableViewDelegate
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // TODO: переход на экран с детальной информацией по игре если результат
//        // или новый поиск по последним поисковым запросам (может буду хранить выдачу)
//    }

}
