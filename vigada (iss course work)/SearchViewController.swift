//
//  SearchViewController.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 20.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController {
    // MARK: - Properties
    private let loaderView = UIElements().containerView
    private let loaderTintView = UIElements().containerView
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let reuseId = "UITableViewCellreuseId"
    private var searchController: UISearchController?
    private var pendingRequestWorkItem: DispatchWorkItem?
    private var isRecentSearchCalls = true
    private var isSearch = false

    // Core Data
    let stackCoreData = CoreDataStack.shared
    private let coreDataManager = CoreDataManager()
    fileprivate lazy var searchRequestFRC: NSFetchedResultsController<MORecentSearchRequest> = {
        let fetchRequest = NSFetchRequest<MORecentSearchRequest>()
        fetchRequest.entity = MORecentSearchRequest.entity()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timeRequest", ascending: false)]
        fetchRequest.fetchBatchSize = 24
        let frcontroller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: stackCoreData.persistentContainer.viewContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frcontroller.delegate = self
        return frcontroller
    }()

    var gameModels = [GameModel]()

    // MARK: UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Search"
        view.backgroundColor = UIColor.VGDColor.white

        loadRecentSearchRequestText()

        navigationItem.hidesSearchBarWhenScrolling = false

        // Временные данные для тестирования ЮАЙ
        // Будут удалены, как только пойдем за ними в сеть. Это будет скоро.
        guard let testImage = UIImage(named: "placeholder1") else {
            print("Картинки Демо нет")
            return
        }
        guard let imageData = testImage.jpegData(compressionQuality: 1) else {
            print("ошибка jpg")
            return
        }
        let gameId = "12354"
        let gameImageLink = "blah"
        let gameScreenshotsLinks = ["placeholder1", "placeholder2", "placeholder3", "placeholder4"]
        let gameVideoPreviewImageLink = "blah"
        let link = "https://media.rawg.io/media/stories/a30/a3017aa7740f387a158cbc343524275b.mp4"
        let gameModel1 = GameModel(gameCategory: .best, gameId: gameId, gameTitle: "Zelda", gameImage: imageData, gameImageLink: gameImageLink, gameDescription: string,
                                   gameScreenshots: [imageData, imageData, imageData, imageData, imageData], gameScreenshotsLinks: gameScreenshotsLinks,
                                   gameVideoPreviewImage: imageData, gameVideoPreviewImageLink: gameVideoPreviewImageLink, gameVideoLink: link)
        let gameModel2 = GameModel(gameCategory: .later, gameId: gameId, gameTitle: "Cyberpunk 2077", gameImage: imageData, gameImageLink: gameImageLink, gameDescription: string,
                                   gameScreenshots: [imageData, imageData, imageData, imageData, imageData], gameScreenshotsLinks: gameScreenshotsLinks,
                                   gameVideoPreviewImage: imageData, gameVideoPreviewImageLink: gameVideoPreviewImageLink, gameVideoLink: link)
        let gameModel3 = GameModel(gameCategory: .recent, gameId: gameId, gameTitle: "Sims", gameImage: imageData, gameImageLink: gameImageLink, gameDescription: string,
                                   gameScreenshots: [imageData, imageData, imageData, imageData, imageData], gameScreenshotsLinks: gameScreenshotsLinks,
                                   gameVideoPreviewImage: imageData, gameVideoPreviewImageLink: gameVideoPreviewImageLink, gameVideoLink: link)
        let gameModel4 = GameModel(gameCategory: .recent, gameId: gameId, gameTitle: "Contra", gameImage: imageData, gameImageLink: gameImageLink, gameDescription: string,
                                   gameScreenshots: [imageData, imageData, imageData, imageData, imageData], gameScreenshotsLinks: gameScreenshotsLinks,
                                   gameVideoPreviewImage: imageData, gameVideoPreviewImageLink: gameVideoPreviewImageLink, gameVideoLink: link)
        let gameModel5 = GameModel(gameCategory: .best, gameId: gameId, gameTitle: "Gorky 17", gameImage: imageData, gameImageLink: gameImageLink, gameDescription: string,
                                   gameScreenshots: [imageData, imageData, imageData, imageData, imageData], gameScreenshotsLinks: gameScreenshotsLinks,
                                   gameVideoPreviewImage: imageData, gameVideoPreviewImageLink: gameVideoPreviewImageLink, gameVideoLink: link)
        let gameModel6 = GameModel(gameCategory: .wishes, gameId: gameId, gameTitle: "Football Manager", gameImage: imageData, gameImageLink: gameImageLink, gameDescription: string,
                                   gameScreenshots: [imageData, imageData, imageData, imageData, imageData], gameScreenshotsLinks: gameScreenshotsLinks,
                                   gameVideoPreviewImage: imageData, gameVideoPreviewImageLink: gameVideoPreviewImageLink, gameVideoLink: link)

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
        tableView.keyboardDismissMode = .onDrag

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

        setupsearchController()
    }

    func setupsearchController() {
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

    func searchGame(searchText: String, delay: Int = 1550) {
        let delay = delay
        if searchText.count > 2 {
            pendingRequestWorkItem?.cancel()
            let requestWorkItem = DispatchWorkItem { [weak self] in
                print("ищу \(searchText)...")
                self?.isSearch = true
                // сохраняю эту строчку в кордату
                guard let sections = self?.searchRequestFRC.sections else {
                    fatalError("Секции нет")
                }
                let section = sections[0]
                guard let itemsInSection = section.objects as? [MORecentSearchRequest] else {
                    fatalError("Объектов нет")
                }
                let isExist = itemsInSection.filter { $0.recentSearchText == searchText }
                if isExist.isEmpty {
                     self?.coreDataManager.saveRecentSearchRequestText(searchText)
                } else {
                    print("было уже")
                }

                self?.loaderView.vgdLoader(.start, durationIn: 1.6)
                UIView.animate(withDuration: 1.4) {
                    self?.loaderTintView.alpha = 0.4
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
                    self?.tableView.scrollToTop()
                }
            }
            pendingRequestWorkItem = requestWorkItem
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay), execute: requestWorkItem)
        } else {
            print("поле поиска не активно")
        }
    }

    func loadRecentSearchRequestText() {
        print("грузим из кордаты поисковую строку")
        do {
            try searchRequestFRC.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: - Extensions
extension SearchViewController: UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return searchRequestFRC.sections?.count ?? 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isRecentSearchCalls {
            return searchRequestFRC.sections?[section].numberOfObjects ?? 0
        } else {
            return gameModels.count // колво игр в выдаче из сети
        }

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isRecentSearchCalls {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchRecentTableViewCell", for: indexPath) as? SearchRecentTableViewCell
            let model = modelFromCoreData(indexPath: indexPath)
            cell?.settingView.settingLabel.text = model.recentSearchText
            cell?.selectionStyle = .none
            if let cell = cell {
                return cell
            } else {
                return defaultCell(indexPath: indexPath)
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as? SearchResultTableViewCell
            let imageData = gameModels[indexPath.row].gameImage
            let image = UIImage(data: imageData) ?? UIImage(named: "placeholder3")
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
        if isRecentSearchCalls {
            let model = modelFromCoreData(indexPath: indexPath)
            let text = model.recentSearchText
            searchGame(searchText: text, delay: 0)
        } else {
            print("переход на экран с инфой по игре")
            searchController?.searchBar.resignFirstResponder()
            let nextViewController = GameDetailsViewController()
            //nextViewController.gameTemp = gameModels[indexPath.row]
            nextViewController.game = gameModels[indexPath.row]
            if let navigator = navigationController {
                navigator.pushViewController(nextViewController, animated: true)
            }
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !isRecentSearchCalls {
            let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 15, 0)
            cell.layer.transform = rotationTransform
            cell.alpha = 0.5
            UIView.animate(withDuration: 0.55) {
                cell.layer.transform = CATransform3DIdentity
                cell.alpha = 1
            }
        }
    }

    func modelFromCoreData(indexPath: IndexPath) -> MORecentSearchRequest {
        guard let sections = searchRequestFRC.sections else {
            fatalError("Секции нет")
        }

        let section = sections[indexPath.section]
        guard let itemsInSection = section.objects as? [MORecentSearchRequest] else {
            fatalError("Объектов нет")
        }

        let model = itemsInSection[indexPath.row]
        return model
    }

}

extension SearchViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("update")
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("BeginEditing")
        navigationItem.hidesSearchBarWhenScrolling = true
        if isSearch {
            loadRecentSearchRequestText()
        }
        isRecentSearchCalls = true
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        print("cancel")
        if isSearch {
            isRecentSearchCalls = false
            let sectionToReload = 0
            let indexSet: IndexSet = [sectionToReload]
            tableView.reloadSections(indexSet, with: .automatic)
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchGame(searchText: searchText)
    }
}
