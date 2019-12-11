//
//  GameDetailsViewController.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 21.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit
import AVKit

class GameDetailsViewController: UIViewController {
    // MARK: - Properties
    // Core Data
    let stackCoreData = CoreDataStack.shared
    private let coreDataManager = CoreDataManager()
    // Network
    private let networkManager = NetworkManager()

    private let tableView = UITableView(frame: .zero, style: .plain)
    private let reuseId = "UITableViewCellreuseId"
    private let favoritesPanelLikeButtonView = FavoritesPanelLikeButtonView()
    private let favoritesSelectActionView = FavoritesSelectActionView()

    private let containerViewForTable = UIElements().containerView
    private let viewWithShadowAndCorners = UIElements().containerView
    private let closeControllerButton = UIElements().imageView

    private let loaderView = UIElements().containerView
    private let loaderTintView = UIElements().containerView

    private let window = UIApplication.shared.windows[0]
    private var safeFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    private var bottomSafeAreaHeight: CGFloat = 0

    private let isInternet = "isInternet"

    private let strechyContainerHeaderView = UIView()
    private let strechyView = StrechyHeaderView()
    private let strechyShift: CGFloat = 300
    private let strechyShiftMax: CGFloat = 700

    // констрейнты для анимации таблиции при смене категории
    private var tableviewContainerShiftConstraint = NSLayoutConstraint()
    private var favorSelectActionViewHeightConstraint = NSLayoutConstraint()
    private var favorSelectActionViewWidthConstraint = NSLayoutConstraint()

    private var favIcon = UIImage(named: "fav.add")
    private var favIconTintColor = UIColor.VGDColor.black

    var game: GameModel?

    var gameTemp: VGDModelResult?
    var gameBackgroundImageTemp: Data?

    // MARK: UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.VGDColor.white
        // Проверяем есть интернет или нет.
        let networkManager = NetworkManager()
        networkManager.delegate = self
        networkManager.checkInternet()

        safeFrame = window.safeAreaLayoutGuide.layoutFrame
        bottomSafeAreaHeight = window.frame.maxY - safeFrame.maxY

        setupScreen()

        for index in 0..<favoritesPanelLikeButtonView.categoryPanelStack.arrangedSubviews.count {
            let gestureTap = UITapGestureRecognizer(target: self, action: #selector(self.stackViewTapped(_:)))
            favoritesPanelLikeButtonView.categoryPanelStack.arrangedSubviews[index].addGestureRecognizer(gestureTap)
            favoritesPanelLikeButtonView.categoryPanelStack.arrangedSubviews[index].tag = index
        }

        // Если интернета нет, то засетапится эта кнопка
        setupCloseControllerButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
        self.tabBarController?.tabBar.isHidden = true

        if game == nil {
            guard let gameId = gameTemp?.id else {
                return
            }
            startLoader()
            coreDataManager.checkAndLoadGame(gameId: "\(gameId)", completion: { game in
                DispatchQueue.main.async {
                    if let game = game {
                        let logger = VGDLogger(type: Info())
                        logger.log(message: "Загрузил игру из кор даты", value: game.gameTitle)
                        self.game = game
                        self.strechyView.strechyImage.image = UIImage(data: game.gameImage)
                        self.strechyView.titleGame.text = game.gameTitle
                        self.setupFavIcon()
                        self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                        self.stopLoader()
                    } else {
                        let logger = VGDLogger(type: Info())
                        logger.log(message: "Нет такой игры в базе. Создадим её.", value: "")
                        self.createGameModelFromNetworkData()
                    }
                }
            })
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.hidesBarsOnSwipe = false
    }

    // MARK: - Method
    private func startLoader() {
        self.loaderView.vgdLoader(.start, durationIn: 0.6)
        UIView.animate(withDuration: 0.4) {
            self.loaderTintView.alpha = 0.7
        }
    }

    private func stopLoader() {
        self.loaderView.vgdLoader(.stop)
        self.loaderTintView.alpha = 0
    }

    private func createGameModelFromNetworkData() {

        guard let gameTitle = gameTemp?.name,
            let gameImage = gameBackgroundImageTemp,
            let gameImageLink = gameTemp?.backgroundImage,
            let gameId = gameTemp?.id else {
                return
        }

        strechyView.strechyImage.image = UIImage(data: gameImage)
        strechyView.titleGame.text = gameTitle

        var gameDescription = ""
        var gameScreenshots: [Data?] = [nil]

        var gameScreenshotsLinks = [String?]()
        if let screenshots = gameTemp?.shortScreenshots {
            for index in 0..<screenshots.count {
                gameScreenshotsLinks.append(screenshots[index].image)
            }
        } else {
            gameScreenshotsLinks = [nil]
        }

        var gameVideoPreviewImage: Data?
        let gameVideoPreviewImageLink = gameTemp?.clip?.preview
        let gameVideoLink = gameTemp?.clip?.clips?.full

        let gameTest = GameModel(gameId: "\(gameId)", gameTitle: gameTitle, gameImage: gameImage, gameImageLink: gameImageLink, gameDescription: gameDescription, gameScreenshots: gameScreenshots, gameScreenshotsLinks: gameScreenshotsLinks, gameVideoPreviewImage: gameVideoPreviewImage, gameVideoPreviewImageLink: gameVideoPreviewImageLink, gameVideoLink: gameVideoLink)
        game = gameTest

        // тут запускаем качалку с диспатчгрупп и релоадим таблицу
        let group = DispatchGroup()
        let queueDetails = DispatchQueue(label: "com.GameDetails")

        group.enter()
        queueDetails.async(group: group) {
            let gameDetailsLink = "https://api.rawg.io/api/games/\(gameId)"
            self.networkManager.getGamesDescription(url: gameDetailsLink, completion: { description, _ in
                gameDescription = description?.descriptionRaw ?? ""
                group.leave()
            })
        }

        group.enter()
        queueDetails.async(group: group) {
            if let previewLink = gameVideoPreviewImageLink {
                self.networkManager.getImageByStringUrl(url: previewLink, completion: { (image, _) in
                    gameVideoPreviewImage = image
                    group.leave()
                })
            } else {
                group.leave()
            }
        }

        group.enter()
        if !gameScreenshotsLinks.isEmpty {
            let groupScreenshots = DispatchGroup()
            for url in gameScreenshotsLinks {
                if let url = url {
                    groupScreenshots.enter()
                    self.networkManager.getImageByStringUrl(url: url, completion: { (image, _) in
                        gameScreenshots.append(image)
                        groupScreenshots.leave()
                    })
                }
            }

            groupScreenshots.notify(queue: .main) {
                group.leave()
            }
        } else {
            group.leave()
        }

        group.notify(queue: .main) {
            gameScreenshots.removeFirst()
            let gameTest = GameModel(gameId: "\(gameId)", gameTitle: gameTitle, gameImage: gameImage, gameImageLink: gameImageLink, gameDescription: gameDescription, gameScreenshots: gameScreenshots, gameScreenshotsLinks: gameScreenshotsLinks, gameVideoPreviewImage: gameVideoPreviewImage, gameVideoPreviewImageLink: gameVideoPreviewImageLink, gameVideoLink: gameVideoLink)
            self.game = gameTest
            self.stopLoader()
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            // Сохраняем игру в Core Data
            self.saveGameToCoreData()
        }
    }

    private func saveGameToCoreData() {
        // Сохраняем игру в Core Data
        if let game = game {
            coreDataManager.saveGame(game)
        } else {
            let logger = VGDLogger(type: Error())
            logger.log(message: "Сохранялка в базу данных не прошла. saveGameToCoreData", value: "nil")
        }
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

    // MARK: - Action
    // close controller method if no internet
    @objc func closeTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }

    // выбрали категорию
    @objc func stackViewTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        if let stackTag = gestureRecognizer.view?.tag {
            var icon = Favorites.segmentIcons.data[stackTag]
            var color = UIElements().favoritesColors[stackTag]

            //  меняем категорию у модели(игры) и сохраняем её в базу
            switch stackTag {
            case 0:
                game?.gameCategory = .best
            case 1:
                game?.gameCategory = .wishes
            case 2:
                game?.gameCategory = .later
            case 3:
                game?.gameCategory = .recent
            default:
                let logger = VGDLogger(type: Error())
                logger.log(message: "Not right category", value: stackTag)
            }

            // Сохраняем игру в Core Data
            saveGameToCoreData()

            // тинт иконки на стике
            favoritesSelectActionView.favoritesIcon.image = UIImage(named: icon)?.tinted(with: UIColor.VGDColor.white)

            favoritesSelectActionView.backgroundColor = color
            tableviewContainerDown()

            self.favorSelectActionViewHeightConstraint.constant = 64
            self.favorSelectActionViewWidthConstraint.constant = 64
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
                self.favoritesSelectActionView.alpha = 1
            }, completion: { _ in
                self.favoritesSelectActionViewHide()
            })
            UIView.transition(with: self.tableView, duration: 0.1, options: .transitionCrossDissolve,
                              animations: {
                                if stackTag == 3 {
                                    icon = "fav.add"
                                    color = UIColor.VGDColor.black
                                }
                                self.strechyView.addFavoritesButton.setImage(UIImage(named: icon), for: .normal)
                                self.strechyView.tintContainer.backgroundColor = color
            })
        }
    }

    @objc func favoritesSelectActionViewHide() {
        self.favorSelectActionViewHeightConstraint.constant = 104
        self.favorSelectActionViewWidthConstraint.constant = 104
        UIView.animate(withDuration: 0.6, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
            self.favoritesSelectActionView.alpha = 0
        }, completion: nil)
    }

    @objc func addFavoritesTapped(_ sender: UIButton) {
        self.tableViewContainerUp()
    }

    @objc func playButtonIsTapped(_ sender: UIButton) {
        guard let link = game?.gameVideoLink else {
            return
        }
        self.playTrailer(link)
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

        containerViewForTable.layer.shadowRadius = 2.0
        containerViewForTable.layer.shadowOpacity = 0.4
        containerViewForTable.layer.shadowOffset = CGSize(width: 0, height: 3)
        containerViewForTable.layer.masksToBounds = false
        view.addSubview(containerViewForTable)
        tableviewContainerShiftConstraint = containerViewForTable.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        NSLayoutConstraint.activate([
            containerViewForTable.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 0),
            containerViewForTable.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0),
            containerViewForTable.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            tableviewContainerShiftConstraint
            ])

        viewWithShadowAndCorners.backgroundColor = .clear
        if bottomSafeAreaHeight == 0 {
            viewWithShadowAndCorners.layer.cornerRadius = 0
        } else {
            viewWithShadowAndCorners.layer.cornerRadius = bottomSafeAreaHeight / 2
        }
        viewWithShadowAndCorners.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        viewWithShadowAndCorners.clipsToBounds = true
        containerViewForTable.addSubview(viewWithShadowAndCorners)
        NSLayoutConstraint.activate([
            viewWithShadowAndCorners.topAnchor.constraint(equalTo: containerViewForTable.topAnchor, constant: 0),
            viewWithShadowAndCorners.leadingAnchor.constraint(equalTo: containerViewForTable.leadingAnchor, constant: 0),
            viewWithShadowAndCorners.trailingAnchor.constraint(equalTo: containerViewForTable.trailingAnchor, constant: -0),
            viewWithShadowAndCorners.bottomAnchor.constraint(equalTo: containerViewForTable.bottomAnchor, constant: -0)
            ])

        setupTableView()
        setupStrechyHeader()
        setupFavSelectStick()
        setupLoader()
    }

    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: strechyShift, left: 0, bottom: 0, right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(GDDescriptionTableViewCell.self, forCellReuseIdentifier: "GDDescriptionTableViewCell")
        tableView.register(GDVideoTableViewCell.self, forCellReuseIdentifier: "GDVideoTableViewCell")
        tableView.register(GDScreenshotsTableViewCell.self, forCellReuseIdentifier: "GDScreenshotsTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = UIColor.VGDColor.clear
        tableView.backgroundColor = UIColor.VGDColor.white
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false

        viewWithShadowAndCorners.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: containerViewForTable.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: containerViewForTable.trailingAnchor, constant: -0),
            tableView.topAnchor.constraint(equalTo: containerViewForTable.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: containerViewForTable.bottomAnchor, constant: 0)
            ])
    }

    private func setupLoader() {
        loaderTintView.alpha = 0
        loaderTintView.layer.cornerRadius = 8
        loaderTintView.backgroundColor = UIColor.VGDColor.black
        view.addSubview(loaderTintView)
        NSLayoutConstraint.activate([
            loaderTintView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            loaderTintView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            loaderTintView.widthAnchor.constraint(equalToConstant: 60),
            loaderTintView.heightAnchor.constraint(equalToConstant: 60)
            ])
        view.addSubview(loaderView)
        NSLayoutConstraint.activate([
            loaderView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            loaderView.widthAnchor.constraint(equalToConstant: 40),
            loaderView.heightAnchor.constraint(equalToConstant: 40)
            ])
    }

    func setupStrechyHeader() {
        strechyContainerHeaderView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: strechyShift)
        strechyContainerHeaderView.contentMode = .scaleAspectFill
        strechyContainerHeaderView.clipsToBounds = true
        containerViewForTable.addSubview(strechyContainerHeaderView)

        if let imageData = game?.gameImage {
            let image = UIImage(data: imageData) ?? UIImage(named: "placeholder1")
            strechyView.strechyImage.image = image
        } else {
            strechyView.strechyImage.image = UIImage(named: "placeholder1")
        }
        strechyView.titleGame.text = game?.gameTitle
        strechyContainerHeaderView.addSubview(strechyView)
        NSLayoutConstraint.activate([
            strechyView.leadingAnchor.constraint(equalTo: strechyContainerHeaderView.leadingAnchor, constant: 0),
            strechyView.trailingAnchor.constraint(equalTo: strechyContainerHeaderView.trailingAnchor, constant: -0),
            strechyView.topAnchor.constraint(equalTo: strechyContainerHeaderView.topAnchor, constant: 0),
            strechyView.bottomAnchor.constraint(equalTo: strechyContainerHeaderView.bottomAnchor, constant: 0)
            ])

        setupFavIcon()

        strechyView.addFavoritesButton.setImage(favIcon, for: .normal)
        strechyView.tintContainer.backgroundColor = favIconTintColor
        strechyView.addFavoritesButton.addTarget(self, action: #selector(self.addFavoritesTapped(_:)), for: .touchUpInside)
    }

    func setupFavIcon() {
        if let category = game?.gameCategory {
            switch category {
            case .best:
                favIcon = UIImage(named: "fav.\(category.rawValue)")
                favIconTintColor = UIElements().favoritesColors[0]
            case .wishes:
                favIcon = UIImage(named: "fav.\(category.rawValue)")
                favIconTintColor = UIElements().favoritesColors[1]
            case .later:
                favIcon = UIImage(named: "fav.\(category.rawValue)")
                favIconTintColor = UIElements().favoritesColors[2]
            case .recent:
                favIcon = UIImage(named: "fav.add")
            }
        } else {
            favIcon = UIImage(named: "fav.add")
        }

        strechyView.addFavoritesButton.setImage(favIcon, for: .normal)
        strechyView.tintContainer.backgroundColor = favIconTintColor
    }

    func setupFavSelectStick() {
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

    func setupCloseControllerButton() {
        if !UserDefaults.standard.bool(forKey: isInternet) {
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

}

// MARK: - Extensions
// MARK: UITableViewDataSource
extension GameDetailsViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = showDescriptionCell(indexPath: indexPath)
            return cell
        case 1:
            let cell = showScreenshotsCell(indexPath: indexPath)
            return cell
        case 2:
            let cell = showVideoCell(indexPath: indexPath)
            return cell
        default:
            return defaultCell(indexPath: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let nextViewController = ScreenshotsCollectionViewController()
            if let gameGameScreenshots = game?.gameScreenshots {
                nextViewController.gameScreenshotsArray = gameGameScreenshots
                if let navigator = navigationController {
                    navigator.pushViewController(nextViewController, animated: true)
                } else {
                    nextViewController.isInternetSG = false
                    nextViewController.modalTransitionStyle = .crossDissolve
                    self.present(nextViewController, animated: false, completion: nil)
                }
            }

        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yCoordinate = strechyShift - (scrollView.contentOffset.y + strechyShift)
        let height = min(max(yCoordinate, 0), strechyShiftMax)
        strechyContainerHeaderView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height)
        if (scrollView.contentOffset.y >= 0) && (scrollView.contentOffset.y <= strechyShift) {
            self.strechyView.addFavoritesButton.alpha = 0
        } else if scrollView.contentOffset.y < 0 {
            let percent: CGFloat = scrollView.contentOffset.y / strechyShift
            self.strechyView.addFavoritesButton.alpha = abs(percent)
            self.strechyView.tintContainer.alpha = 0.6*abs(percent)
        }
    }

    func defaultCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        cell.textLabel?.text = "Broke 'Settings' table row"
        return cell
    }

    func showDescriptionCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GDDescriptionTableViewCell", for: indexPath) as? GDDescriptionTableViewCell
        cell?.selectionStyle = .none
        cell?.gameDescription.text = self.game?.gameDescription
        if let cell = cell {
            return cell
        } else {
            return defaultCell(indexPath: indexPath)
        }
    }

    func showScreenshotsCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GDScreenshotsTableViewCell", for: indexPath) as? GDScreenshotsTableViewCell
        cell?.selectionStyle = .none
        if let gameScreenshots = self.game?.gameScreenshots {
            let gameScreenshotsFilter = gameScreenshots.compactMap { $0 }
            let gamesScreenshotsCount = gameScreenshotsFilter.count
            var tempIamageDataArray = [Data?]()
            for index in 0...3 {
                if index < gamesScreenshotsCount {
                    tempIamageDataArray.append(gameScreenshotsFilter[index])
                } else {
                    guard let image = UIImage(named: "placeholder2") else {
                        fatalError("Потерялся плейсхолдер в стеке")
                    }
                    tempIamageDataArray.append(image.pngData())
                }
            }
            if let image1 = tempIamageDataArray[0],
                let image2 = tempIamageDataArray[1],
                let image3 = tempIamageDataArray[2],
                let image4 = tempIamageDataArray[3] {
                cell?.screenshotCell1.image = UIImage(data: image1)
                cell?.screenshotCell2.image = UIImage(data: image2)
                cell?.screenshotCell3.image = UIImage(data: image3)
                cell?.screenshotCell4.image = UIImage(data: image4)
            }
        }

        if let cell = cell {
            return cell
        } else {
            return defaultCell(indexPath: indexPath)
        }
    }

    func showVideoCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GDVideoTableViewCell", for: indexPath) as? GDVideoTableViewCell
        cell?.selectionStyle = .none
        if let previewData = self.game?.gameVideoPreviewImage {
            cell?.gameImagePreview.image = UIImage(data: previewData)
        }
        cell?.playButton.addTarget(self, action: #selector(self.playButtonIsTapped(_:)), for: .touchUpInside)
        if let cell = cell {
            return cell
        } else {
            return defaultCell(indexPath: indexPath)
        }
    }

}
// MARK: Check internet connection
extension GameDetailsViewController: CheckInternetDelegate {
    func checkInternet(_ isInternet: Bool) {
        let connection = UserDefaults.standard.bool(forKey: self.isInternet)
        //Если соединение вдруг появилось, то предложим пользователю перейти на главный экран
        if connection == false && isInternet == true {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [] in
                let alert = UIAlertController(title: "Network ", message: "Connection is ok! \nLoad games base?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                    let nextViewController = LoaderViewController()
                    nextViewController.modalTransitionStyle = .crossDissolve
                    self.present(nextViewController, animated: true, completion: nil)
                }))
                alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
// MARK: Video player
extension GameDetailsViewController {
    func playTrailer(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        let player = AVPlayer(url: url)
        let controller = VGDVideoController()
        controller.modalPresentationStyle = .overFullScreen
        controller.player = player
        self.present(controller, animated: true) {
            player.play()
        }
    }
}
