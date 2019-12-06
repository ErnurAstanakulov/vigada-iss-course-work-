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

    private let tableView = UITableView(frame: .zero, style: .plain)
    private let reuseId = "UITableViewCellreuseId"
    private let favoritesPanelLikeButtonView = FavoritesPanelLikeButtonView()
    private let favoritesSelectActionView = FavoritesSelectActionView()

    private let containerViewForTable = UIElements().containerView
    private let viewWithShadowAndCorners = UIElements().containerView
    private let closeControllerButton = UIElements().imageView

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

    var gameTemp: GameModel?

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

        // TODO: Если попали сюда из фаворитсов, то всё ок. Сохранять модель в кордату будем только при смене категории.
        // Если попали сюда из любого другого экрана (Поиск, Хоум, Брауз), то качаем из сети инфу по игре. Текст прийдет быстро. Главная картинка уже есть. (релоадим таблицу)
        // Качаем превью для видео, адрес уже есть, в это время там плейсхордер. Линк на видео тоже есть
        // По комплишену качаем скриншоты (с задержкой например ). По комплишену релоадим таблицу.
        // И сохраняем модель в кордату
        // на случай если кто-то быстро зашел и ушел, то поставим ограничение по времени

        if game == nil {
            print("Мы пришли откуда-то и модели нет. Возьми временные данные")
            // TODO сделать поисх по gameId в кордате и если найдна запись, то показать из кордаты инфу
            // и из них инициализируй временную модель 'game'
            // скачаются скриншоты и по комплишену инициализируем модель, и отдадим её кордате на сохранение
            // перегрузим таблицу из модели
        } else {
            print("Мы пришли из фаворитсов и у нас есть модель!")
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.hidesBarsOnSwipe = false
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
                print("not right category")
            }

            // Сохраняем игру в Core Data
            if let game = game {
                coreDataManager.saveGame(game)
            } else {
                print("сохранялка в базу данных не прошла. Модель nil")
            }

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
                                //self.tableView.reloadData()
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
        strechyView.addFavoritesButton.addTarget(self, action: #selector(self.addFavoritesTapped(_:)), for: .touchUpInside)
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
            nextViewController.gameScreenshotsArray = game?.gameScreenshots
            if let navigator = navigationController {
                navigator.pushViewController(nextViewController, animated: true)
            } else {
                nextViewController.isInternetSG = false
                nextViewController.gameScreenshotsArray = game?.gameScreenshots
                nextViewController.modalTransitionStyle = .crossDissolve
                self.present(nextViewController, animated: false, completion: nil)
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

        if let game = self.game {
            cell?.screenshotCell1.image = UIImage(data: game.gameScreenshots[0])
            cell?.screenshotCell2.image = UIImage(data: game.gameScreenshots[1])
            cell?.screenshotCell3.image = UIImage(data: game.gameScreenshots[2])
            cell?.screenshotCell4.image = UIImage(data: game.gameScreenshots[3])
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
