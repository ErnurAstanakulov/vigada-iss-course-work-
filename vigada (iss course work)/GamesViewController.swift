//
//  GamesViewController.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 07.12.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

class GamesViewController: UIViewController {
    // MARK: - Properties
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let reuseId = "UITableViewCellreuseId"
    private let loaderView = UIElements().containerView
    private let loaderTintView = UIElements().containerView

    private let urlBuilder = URLBuilder()

    private let networkManager = NetworkManager()
    // буферные переменные
    var gameLink = ""
    var gameListCount = 1
    var gamesCollection = [VGDModelResult]()
    var gamesImagesbuffer = [Int: Data]()
    var page = 1
    var titleScreen: String?

    // MARK: - UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = titleScreen ?? "Games"
        view.backgroundColor = UIColor.VGDColor.white

        setupTableView()
    }

    // MARK: - Set up
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: "SearchResultTableViewCell")
        tableView.register(SearchRecentTableViewCell.self, forCellReuseIdentifier: "SearchRecentTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = UIColor.VGDColor.clear
        tableView.keyboardDismissMode = .onDrag

        tableView.backgroundColor = UIColor.VGDColor.white
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -0)
            ])

        loaderTintView.alpha = 0
        loaderTintView.backgroundColor = UIColor.VGDColor.black
        view.addSubview(loaderTintView)
        NSLayoutConstraint.activate([
            loaderTintView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            loaderTintView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
            loaderTintView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            loaderTintView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -0)
            ])
        view.addSubview(loaderView)
        NSLayoutConstraint.activate([
            loaderView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            loaderView.widthAnchor.constraint(equalToConstant: 40),
            loaderView.heightAnchor.constraint(equalToConstant: 40)
            ])
    }

    func startLoader() {
        self.loaderView.vgdLoader(.start, durationIn: 1.6)
        UIView.animate(withDuration: 1.4) {
            self.loaderTintView.alpha = 0.4
        }
    }

    func searchGames() {
        self.networkManager.getGamesListByStringUrl(url: gameLink, completion: {gamesList, _ in
            DispatchQueue.main.async {
                self.gameListCount = gamesList?.count ?? 1
                self.gamesCollection += gamesList?.results ?? []
                self.loaderView.vgdLoader(.stop)
                self.loaderTintView.alpha = 0
                self.tableView.reloadData()
                self.gameLink = gamesList?.next ?? ""
            }
        })
    }

}

// MARK: - Extensions
extension GamesViewController: UITableViewDataSource, UITableViewDelegate {

    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesCollection.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Постраничная подзагрузка из сети
        if (indexPath.row == gamesCollection.count - 1) && (gamesCollection.count < gameListCount) {
            startLoader()
            searchGames()
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as? SearchResultTableViewCell

        let game = gamesCollection[indexPath.row]
        cell?.gameTitle.text = game.name
        //если картинки нет в буфере, то грузим её из сети
        if self.gamesImagesbuffer[indexPath.row] == nil {
            if let imageLink = game.backgroundImage {
                networkManager.getImageByStringUrl(url: imageLink, completion: { data, _ in
                    guard let data = data else {
                        return
                    }
                    DispatchQueue.main.async {
                        self.gamesImagesbuffer[indexPath.row] = data
                        let image = UIImage(data: data) ?? UIImage(named: "placeholder3")
                        guard let imageInCell = cell?.gameImageView else {
                            fatalError("тут у пал и отжался")
                        }
                        UIView.transition(with: imageInCell, duration: 0.6, options: .transitionCrossDissolve, animations: {
                            cell?.gameImageView.image = image
                        }, completion: nil)

                    }
                })
            }
        } else {
            guard let data = self.gamesImagesbuffer[indexPath.row] else {
                fatalError("а где же картинка в буфере?")
            }
            let image = UIImage(data: data) ?? UIImage(named: "placeholder4")
            cell?.gameImageView.image = image
        }

        cell?.selectionStyle = .none
        if let cell = cell {
            return cell
        } else {
            return defaultCell(indexPath: indexPath)
        }
    }

    func defaultCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        cell.textLabel?.text = "Broke 'Settings' table row"
        return cell
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("переход на экран с инфой по игре")
        let nextViewController = GameDetailsViewController()
        let game = gamesCollection[indexPath.row]
        nextViewController.gameTemp = game
        nextViewController.gameBackgroundImageTemp = gamesImagesbuffer[indexPath.row]
        if let navigator = navigationController {
            navigator.pushViewController(nextViewController, animated: true)
        }
    }
}
