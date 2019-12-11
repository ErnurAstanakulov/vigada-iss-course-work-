//
//  BrowseViewController.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 20.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

class BrowseViewController: UIViewController {
    // MARK: - Properties
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let reuseId = "UITableViewCellreuseId"

    private let apiCollectionData = APICollectionData()
    private let networkManager = NetworkManager()

    private let loaderView = UIElements().containerView
    private let loaderTintView = UIElements().containerView

    var topCollection = [String: (image: Data, model: VGDModelGamesRequest)]()
    var topCollectionTitles = [String]()
    var topCollectionImages = [Data]()
    var agesCollection = [String: (image: Data, model: VGDModelGamesRequest)]()
    var agesCollectionTitles = [String]()
    var agesCollectionImages = [Data]()
    var platformsCollection = [String: (image: Data, model: VGDModelGamesRequest)]()
    var platformsCollectionTitles = [String]()
    var platformsCollectionImages = [Data]()

    var kostilCount = 0

    // MARK: - UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Browse"
        view.backgroundColor = UIColor.VGDColor.white

        setupTableView()
        loadCollections()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let cell0FromSection0 = IndexPath(row: 0, section: 0)
        tableView.reloadRows(at: [cell0FromSection0], with: .automatic)
    }

    // MARK: - Set up
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(BrowseQuoteTableViewCell.self, forCellReuseIdentifier: "BrowseQuoteTableViewCell")
        tableView.register(BrowseTopTableviewCell.self, forCellReuseIdentifier: "BrowseTopTableviewCell")
        tableView.register(BrowsePlatformsTableViewCell.self, forCellReuseIdentifier: "BrowsePlatformsTableViewCell")
        tableView.register(BrowseAgesTableViewCell.self, forCellReuseIdentifier: "BrowseAgesTableViewCell")

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = UIColor.VGDColor.clear
        tableView.keyboardDismissMode = .onDrag
        tableView.showsVerticalScrollIndicator = false

        tableView.backgroundColor = UIColor.VGDColor.white
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -0)
            ])

        view.addSubview(loaderView)
        NSLayoutConstraint.activate([
            loaderView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            loaderView.widthAnchor.constraint(equalToConstant: 40),
            loaderView.heightAnchor.constraint(equalToConstant: 40)
            ])
    }

    func loadCollections() {
        let group = DispatchGroup()
        let queuePreLoader = DispatchQueue(label: "com.preLoader")
        startLoader()

        group.enter()
        queuePreLoader.async(group: group) {
            let topCellUrls = self.apiCollectionData.collectionAllGames()
            self.networkManager.preLoad(topCellUrls, completion: {dictionary in
                self.topCollection = dictionary
                for element in dictionary {
                    self.topCollectionTitles.append(element.key)
                    self.topCollectionImages.append(element.value.image)
                }
                group.leave()
            })
        }

        group.enter()
        queuePreLoader.async(group: group) {
            let agesCellUrls = self.apiCollectionData.collectionAges()
            self.networkManager.preLoad(agesCellUrls, completion: {dictionary in
                self.agesCollection = dictionary
                for element in dictionary {
                    self.agesCollectionTitles.append(element.key)
                    self.agesCollectionImages.append(element.value.image)
                }
                group.leave()
            })
        }

        group.enter()
        queuePreLoader.async(group: group) {
            let platformsCellUrls = self.apiCollectionData.collectionPlatformsGames()
            self.networkManager.preLoad(platformsCellUrls, completion: {dictionary in
                self.platformsCollection = dictionary
                self.platformsCollectionTitles.removeAll()
                self.platformsCollectionImages.removeAll()
                for element in dictionary {
                    self.platformsCollectionTitles.append(element.key)
                    self.platformsCollectionImages.append(element.value.image)
                }
                group.leave()
            })
        }

        group.notify(queue: .main) {
            self.stopLoader()
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }

    private func startLoader() {
        self.loaderView.vgdLoader(.start, durationIn: 0.6)
        UIView.animate(withDuration: 0.4) {
            self.loaderTintView.alpha = 0.5
        }
    }

    private func stopLoader() {
        self.loaderView.vgdLoader(.stop)
        self.loaderTintView.alpha = 0
    }

    func topCollectionCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BrowseTopTableviewCell", for: indexPath) as? BrowseTopTableviewCell

        cell?.delegate = self
        cell?.selectionStyle = .none

        let cellCollcetionText = topCollectionTitles
        let cellCollcetionData: [Data] = topCollectionImages

        cell?.cellText = cellCollcetionText
        cell?.cellImage = cellCollcetionData
        if let cell = cell {
            return cell
        } else {
            return defaultCell(indexPath: indexPath)
        }
    }

    func platformsCollectionCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BrowsePlatformsTableViewCell", for: indexPath) as? BrowsePlatformsTableViewCell

        cell?.delegate = self
        cell?.selectionStyle = .none

        let cellCollcetionText = agesCollectionTitles
        let cellCollcetionData: [Data] = agesCollectionImages

        cell?.cellText = cellCollcetionText
        cell?.cellImage = cellCollcetionData
        if let cell = cell {
            return cell
        } else {
            return defaultCell(indexPath: indexPath)
        }
    }

    func agesCollectionCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BrowseAgesTableViewCell", for: indexPath) as? BrowseAgesTableViewCell

        cell?.delegate = self
        cell?.selectionStyle = .none

        let cellCollcetionText = platformsCollectionTitles
        let cellCollcetionData: [Data] = platformsCollectionImages

        cell?.cellText = cellCollcetionText
        cell?.cellImage = cellCollcetionData
        if kostilCount < 2 {
            cell?.setCollectionViewDataSourceDelegate()
            kostilCount += 1
        }

        if let cell = cell {
            return cell
        } else {
            return defaultCell(indexPath: indexPath)
        }
    }

    func quoteCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BrowseQuoteTableViewCell", for: indexPath) as? BrowseQuoteTableViewCell
        let quote = quotesAboutVideoGames.randomElement()
        cell?.settingView.settingLabel.text = quote
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

}

// MARK: - Extensions
extension BrowseViewController: UITableViewDataSource, UITableViewDelegate {

    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.row {
        case 0:
            return quoteCell(indexPath: indexPath)
        case 1:
            return platformsCollectionCell(indexPath: indexPath)
        case 2:
            return topCollectionCell(indexPath: indexPath)
        case 3:
            return agesCollectionCell(indexPath: indexPath)

        default:
            return quoteCell(indexPath: indexPath)
        }
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let logger = VGDLogger(type: Info())
        logger.log(message: "Нажал на ячейку в BrowseViewController", value: indexPath)
    }
}

extension BrowseViewController: BrowseTopTableViewCellTapDelegate {
    func topCollectionCellTapped(_ numberCell: Int) {
        let nextViewController = GamesViewController()
        nextViewController.gameLink = topCollection[topCollectionTitles[numberCell]]?.model.next ?? ""
        nextViewController.gameListCount = topCollection[topCollectionTitles[numberCell]]?.model.count ?? 1
        nextViewController.gamesCollection = topCollection[topCollectionTitles[numberCell]]?.model.results ?? []
        nextViewController.titleScreen = topCollectionTitles[numberCell]
        if let navigator = navigationController {
            navigator.pushViewController(nextViewController, animated: true)
        }
    }
}

extension BrowseViewController: BrowsePlatformsTableViewCellTapDelegate {
    func platformsCollectionCellTapped(_ numberCell: Int) {
        let nextViewController = GamesViewController()
        nextViewController.gameLink = agesCollection[agesCollectionTitles[numberCell]]?.model.next ?? ""
        nextViewController.gameListCount = agesCollection[agesCollectionTitles[numberCell]]?.model.count ?? 1
        nextViewController.gamesCollection = agesCollection[agesCollectionTitles[numberCell]]?.model.results ?? []
        nextViewController.titleScreen = agesCollectionTitles[numberCell]
        if let navigator = navigationController {
            navigator.pushViewController(nextViewController, animated: true)
        }
    }
}

extension BrowseViewController: BrowseAgesTableViewCellTapDelegate {
    func agesCollectionCellTapped(_ numberCell: Int) {
        let nextViewController = GamesViewController()
        nextViewController.gameLink = platformsCollection[platformsCollectionTitles[numberCell]]?.model.next ?? ""
        nextViewController.gameListCount = platformsCollection[platformsCollectionTitles[numberCell]]?.model.count ?? 1
        nextViewController.gamesCollection = platformsCollection[platformsCollectionTitles[numberCell]]?.model.results ?? []
        nextViewController.titleScreen = platformsCollectionTitles[numberCell]
        if let navigator = navigationController {
            navigator.pushViewController(nextViewController, animated: true)
        }
    }
}
