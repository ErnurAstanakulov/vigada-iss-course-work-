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

    private var result = [String]()

    private var tableviewContainerShiftConstraint = NSLayoutConstraint()
    private var favorSelectActionViewHeightConstraint = NSLayoutConstraint()
    private var favorSelectActionViewWidthConstraint = NSLayoutConstraint()

    private var favIcon = UIImage(named: "favoritesCircleFill")
    private var favIconTintColor = UIColor.VGDColor.black
    var storedOffsets = [Int: CGFloat]()
    // MARK: UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Cyberpunk 2077"
        view.backgroundColor = UIColor.VGDColor.white

        let networkManager = NetworkManager()
        networkManager.delegate = self
        // Проверяем есть интернет или нет.
        networkManager.checkInternet()

        self.tabBarController?.tabBar.isHidden = true

        safeFrame = window.safeAreaLayoutGuide.layoutFrame
        bottomSafeAreaHeight = window.frame.maxY - safeFrame.maxY

        setupScreen()

        for index in 0..<favoritesPanelLikeButtonView.categoryPanelStack.arrangedSubviews.count {
            let gestureTap = UITapGestureRecognizer(target: self, action: #selector(self.stackViewTapped(_:)))
            favoritesPanelLikeButtonView.categoryPanelStack.arrangedSubviews[index].addGestureRecognizer(gestureTap)
            favoritesPanelLikeButtonView.categoryPanelStack.arrangedSubviews[index].tag = index
        }

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

        let string = """
Gorky 17 is a role-playing game set in a fictional polish town of Gorky 17.
The town was attacked by mutants and destroyed. Several years after these events a NATO group disappeared near Gorky 17.
You take control of the second team sent to find missing allies.
Another goal of the game is to reveal the reason why monsters appear.\n\nYou manage a group of three people: Cole Sullivan, the operation leader, and his two subordinates.
The characters can be upgraded; the line-up changes during the game.
Gorky 17 features several huge locations you can freely explore while some areas require special items to be opened.\n\nThe game features turn-based battles with a heavy tactical accent.
You are strictly limited in supplies so wise ammo management is a must.
Sometimes you need to fulfill a certain task during fights, such as protecting someone; some fights are time limited.
A character’s death leads to restarting the battle.
"""
        result = string.components(separatedBy: "\n\n")
        //result = string.split(separator: "\n\n ")
        print(result)
        print(result.count)

        // TODO: когда буду показывать инфу, то если игра уже в фаворитсах - показать иконку какую надо, если нет её там, то сердечке в круге
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.hidesBarsOnSwipe = false
    }

    // MARK: - Action
    @objc func closeTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func stackViewTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        if let stackTag = gestureRecognizer.view?.tag {
            let icon = Favorites.segmentIcons.data[stackTag]
            let color = UIElements().favoritesColors
            favoritesSelectActionView.favoritesIcon.image = UIImage(named: icon)?.tinted(with: UIColor.VGDColor.white)
            if stackTag != 3 {
                favIcon = UIImage(named: icon)
                favIconTintColor = color[stackTag]
            } else {
                favIcon = UIImage(named: "favoritesCircleFill")
                favIconTintColor = UIColor.VGDColor.black
            }

            favoritesSelectActionView.backgroundColor = color[stackTag]
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
                                self.tableView.reloadData()
//                                let indexPath = IndexPath(row: 0, section: 0)
//                                self.tableView.reloadRows(at: [indexPath], with: .automatic)
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
        tableView.register(GDSplashTableViewCell.self, forCellReuseIdentifier: "GDSplashTableViewCell")
        tableView.register(GDDescriptionTableViewCell.self, forCellReuseIdentifier: "GDDescriptionTableViewCell")
        tableView.register(GDVideoTableViewCell.self, forCellReuseIdentifier: "GDVideoTableViewCell")
        tableView.register(GDScreenshotsTableViewCell.self, forCellReuseIdentifier: "GDScreenshotsTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = UIColor.VGDColor.clear
        tableView.backgroundColor = .white
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

    @objc func addFavoritesTapped(_ sender: UIButton) {
        self.tableViewContainerUp()
    }

    @objc func playButtonIsTapped(_ sender: UIButton) {
        guard let url = URL(string: "https://media.rawg.io/media/stories/a30/a3017aa7740f387a158cbc343524275b.mp4") else {
            return
        }
        let player = AVPlayer(url: url)
        let controller = AVPlayerViewController()
        //controller.exitsFullScreenWhenPlaybackEnds = true
        controller.modalPresentationStyle = .overFullScreen
        controller.player = player
        self.present(controller, animated: true) {
            player.play()
        }

//        let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
//        let player = AVPlayer(url: videoURL!)
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = self.view.bounds
//        self.view.layer.addSublayer(playerLayer)
//        player.play()

    }

}

// MARK: - Extensions
extension GameDetailsViewController: UITableViewDataSource, UITableViewDelegate {

    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = showSplashCell(indexPath: indexPath)
            return cell
        case 1...result.count:
            let cell = showDescriptionCell(indexPath: indexPath)
            return cell
        case result.count+1:
            let cell = showVideoCell(indexPath: indexPath)
            return cell
        case result.count+2:
            let cell = showScreenshotsCell(indexPath: indexPath)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GDDescriptionTableViewCell", for: indexPath) as? GDDescriptionTableViewCell
            cell?.gameDescription.text = "test"
            cell?.сontainerGameDescription.backgroundColor = UIColor.VGDColor.green
            cell?.selectionStyle = .none
            return cell!
        }
    }

    func showSplashCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GDSplashTableViewCell", for: indexPath) as? GDSplashTableViewCell
        cell?.selectionStyle = .none
        cell?.gameImage.image = UIImage(named: "demo")
        cell?.label.text = title
        cell?.addFavoritesButton.setImage(favIcon, for: .normal)
        //cell?.addFavoritesButton.tintColor = favIconTintColor
        cell?.tintContainer.backgroundColor = favIconTintColor
        cell?.addFavoritesButton.addTarget(self, action: #selector(self.addFavoritesTapped(_:)), for: .touchUpInside)

        if let cell = cell {
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
            cell.textLabel?.text = "Broke 'Settings' table row"
            return cell
        }
    }

    func showDescriptionCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GDDescriptionTableViewCell", for: indexPath) as? GDDescriptionTableViewCell
        cell?.selectionStyle = .none

        if indexPath.row % 2 == 0 {
            cell?.сontainerGameDescription.backgroundColor = UIColor.VGDColor.black
            cell?.gameDescription.textColor = UIColor.VGDColor.white
        } else {
            cell?.сontainerGameDescription.backgroundColor = UIColor.VGDColor.white
            cell?.gameDescription.textColor = UIColor.VGDColor.black
        }

        cell?.gameDescription.text = result[indexPath.row - 1]
        cell?.gameDescription.textAlignment = .left

        if let cell = cell {
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
            cell.textLabel?.text = "Broke 'Settings' table row"
            return cell
        }
    }

    func showVideoCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GDVideoTableViewCell", for: indexPath) as? GDVideoTableViewCell
        cell?.selectionStyle = .none
        cell?.gameImagePreview.image = UIImage(named: "demo")
        cell?.playButton.addTarget(self, action: #selector(self.playButtonIsTapped(_:)), for: .touchUpInside)
        if let cell = cell {
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
            cell.textLabel?.text = "Broke 'Settings' table row"
            return cell
        }
    }

    func showScreenshotsCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GDScreenshotsTableViewCell", for: indexPath) as? GDScreenshotsTableViewCell
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
//        
//    }

}

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
