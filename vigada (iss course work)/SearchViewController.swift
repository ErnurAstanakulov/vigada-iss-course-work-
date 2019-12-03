//
//  SearchViewController.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 20.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    // MARK: - Properties
    private let loaderView = UIElements().containerView
    private let loaderTintView = UIElements().containerView
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let reuseId = "UITableViewCellreuseId"
    private var searchController: UISearchController?
    private var pendingRequestWorkItem: DispatchWorkItem?
    private var isRecentSearchCalls = true

    var gameModels = [GameModel]()
    let testSearchRecent = ["zelda", "mario", "cs", "contra", "sims", "zelda", "mario", "cs", "contra", "sims", "zelda", "mario", "cs", "contra", "sims"]
    // MARK: UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Search"
        view.backgroundColor = .white

        // TODO: загрузить список прошлых поисковых запросов из кордаты

        // Временные данные для тестирования ЮАЙ
        // Будут удалены, как только пойдем за ними в сеть. Это будет скоро.
        guard let testImage = UIImage(named: "demo") else {
            print("Картинки Демо нет")
            return
        }
        guard let imageData = testImage.jpegData(compressionQuality: 1) else {
            print("ошибка jpg")
            return
        }
        let link = "https://media.rawg.io/media/stories/a30/a3017aa7740f387a158cbc343524275b.mp4"
        let gameModel1 = GameModel(gameCategory: .best, gameTitle: "Zelda", gameImage: imageData,
                                   gameDescription: string, gameScreenshots: [], gameVideoPreviewImage: nil, gameVideoLink: link)
        let gameModel2 = GameModel(gameCategory: .later, gameTitle: "Cyberpunk 2077", gameImage: imageData,
                                   gameDescription: string, gameScreenshots: [], gameVideoPreviewImage: nil, gameVideoLink: link)
        let gameModel3 = GameModel(gameCategory: .none, gameTitle: "Sims", gameImage: imageData,
                                   gameDescription: string, gameScreenshots: [], gameVideoPreviewImage: nil, gameVideoLink: link)
        let gameModel4 = GameModel(gameCategory: .recent, gameTitle: "Contra", gameImage: imageData,
                                   gameDescription: string, gameScreenshots: [], gameVideoPreviewImage: nil, gameVideoLink: link)
        let gameModel5 = GameModel(gameCategory: .best, gameTitle: "Gorky 17", gameImage: imageData,
                                   gameDescription: string, gameScreenshots: [], gameVideoPreviewImage: nil, gameVideoLink: link)
        let gameModel6 = GameModel(gameCategory: .wishes, gameTitle: "Football ManagerЖ Football Manager чего-то там", gameImage: imageData,
                                   gameDescription: string, gameScreenshots: [], gameVideoPreviewImage: nil, gameVideoLink: link)

        gameModels = [gameModel1, gameModel2, gameModel3, gameModel4, gameModel5, gameModel6, gameModel1, gameModel2,
                      gameModel3, gameModel4, gameModel5, gameModel6, gameModel1, gameModel2, gameModel3, gameModel4, gameModel5, gameModel6]
        //

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
            loaderView.widthAnchor.constraint(equalToConstant: 60),
            loaderView.heightAnchor.constraint(equalToConstant: 60)
            ])

        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.dimsBackgroundDuringPresentation = false
        searchController?.searchBar.placeholder = "Find the game..."
        searchController?.searchBar.showsCancelButton = false
        searchController?.searchBar.showsBookmarkButton = false
        searchController?.searchBar.barTintColor = UIColor.VGDColor.blue
        searchController?.searchBar.tintColor = UIColor.VGDColor.black
        searchController?.searchBar.delegate = self
        searchController?.searchBar.sizeToFit()
        searchController?.searchBar.searchBarStyle = UISearchBar.Style.minimal
        self.extendedLayoutIncludesOpaqueBars = true
        navigationItem.searchController = searchController
        definesPresentationContext = true

        let textFieldInsideUISearchBar = searchController?.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.font = SFMono.regular.of(size: 14)
    }

    func searchGame(searchText: String, delay: Int = 1250) {
        let delay = delay
        if searchText.count > 2 {
            pendingRequestWorkItem?.cancel()
            let requestWorkItem = DispatchWorkItem { [weak self] in
                print("ищу \(searchText)...")
                // TODO: сохранить эту строчку в кордату

                self?.loaderView.vgdLoader(.start, durationIn: 1.6)
                UIView.animate(withDuration: 0.8) {
                    self?.loaderTintView.alpha = 0.7
                }

                // очищаем массив моделей и буфер картинок, чтобы показывать только ответ последнего поискового запроса (обнуляем состояние)
                //            self?.globalModels.removeAll()
                //            self?.imagesBuffer.removeAll()
                //            self?.page = 1
                // вызов метода поиска
                //            self?.search(by: "\(searchText)")
                // запоминание поискового запроса для последующих постраничных вызовов
                //            self?.searchTextGlobal = searchText

                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [] in
                    //типа пришел результат. Отключаем лоадер и обновляем таблицу
                    self?.loaderView.vgdLoader(.stop)
                    self?.loaderTintView.alpha = 0
                    self?.isRecentSearchCalls = false
                    self?.tableView.reloadData()
                }
            }
            pendingRequestWorkItem = requestWorkItem
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay), execute: requestWorkItem)
        } else {
            print("поле поиска не активно")
        }
    }
}

// MARK: - Extensions
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {

    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isRecentSearchCalls {
            return testSearchRecent.count
        } else {
            return gameModels.count // колво игр в выдаче из сети
        }

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isRecentSearchCalls {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchRecentTableViewCell", for: indexPath) as? SearchRecentTableViewCell
            cell?.settingView.settingLabel.text = testSearchRecent[indexPath.row]
            cell?.selectionStyle = .none
            if let cell = cell {
                return cell
            } else {
                return defaultCell(indexPath: indexPath)
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as? SearchResultTableViewCell
            let imageData = gameModels[indexPath.row].gameImage
            let image = UIImage(data: imageData) ?? UIImage(named: "demo1")
            cell?.gameImageView.image = image
            cell?.gameTitle.text = gameModels[indexPath.row].gameTitle
            cell?.selectionStyle = .none
            if let cell = cell {
                return cell
            } else {
                return defaultCell(indexPath: indexPath)
            }
        }
    }

    func defaultCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        cell.textLabel?.text = "Broke 'Settings' table row"
        return cell
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: переход на экран с детальной информацией по игре если результат
        // или новый поиск по последним поисковым запросам (может буду хранить выдачу)
        if isRecentSearchCalls {
            let text = testSearchRecent[indexPath.row]
            searchGame(searchText: text, delay: 0)
        } else {
            print("переход на экран с инфой по игре")
            searchController?.searchBar.resignFirstResponder()
            //searchController?.searchBar.isHidden = true
            let nextViewController = GameDetailsViewController()
            nextViewController.game = gameModels[indexPath.row]
            if let navigator = navigationController {
                navigator.pushViewController(nextViewController, animated: true)
            }

        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !isRecentSearchCalls {
            let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 35, 0)
            cell.layer.transform = rotationTransform
            cell.alpha = 0.3
            UIView.animate(withDuration: 0.55) {
                cell.layer.transform = CATransform3DIdentity
                cell.alpha = 1
            }
        }
    }

}

extension SearchViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("update")
        isRecentSearchCalls = true
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        print("cancel")
        // Тут сделаем так, чтобы показывать последние поисковые запросы снова
        isRecentSearchCalls = false
        tableView.reloadData()
    }

    // задержку поискового запроса устанавливаем через DispatchWorkItem в 1 секунду
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchGame(searchText: searchText)
    }
}
