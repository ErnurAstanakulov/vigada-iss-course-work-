//
//  HomeViewController.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 20.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    // MARK: - Properties
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let reuseId = "UITableViewCellreuseId"
    private let titleCyka = UIElements().titleLabel
    private let titleBlyat = UIElements().titleLabel

    private let networkManager = NetworkManager()

    var topCollection: VGDModelGamesRequest?
    var preLoadDictionary: [String: VGDModelGamesRequest]?
    var preLoadCollection: [String: VGDModelGamesRequest]?

    typealias CellTuples = (text: String, imageLink: String)
    var cellTables = [CellTuples]()
    var cellCollection = [CellTuples]()

    var cellCollcetionText = [String]()
    var cellCollcetionData = [Data?]()

    // MARK: - UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Home"
        self.navigationItem.title = "VIGADA"
        view.backgroundColor = UIColor.VGDColor.white

        setupTableView()

        setupTableCells()
        setupCollectionCells()
    }

    // MARK: - Set up
    private func setupTableCells() {
        guard let preLoadDictionary = preLoadDictionary else {
            return
        }

        for element in preLoadDictionary {
            var randomInt = 0
            if let range = element.value.results?.count {
                randomInt = Int.random(in: 0..<range)
            }

            let title = element.key
            guard let imageLink = element.value.results?[randomInt].backgroundImage else {
                return
            }
            cellTables.append((title, imageLink))
        }
    }

    private func setupCollectionCells() {
        guard let preLoadCollection = preLoadCollection else {
            return
        }

        for element in preLoadCollection {
            var randomInt = 0
            if let range = element.value.results?.count {
                randomInt = Int.random(in: 0..<range)
            }

            let title = element.key
            guard let imageLink = element.value.results?[randomInt].backgroundImage else {
                return
            }
            cellCollection.append((title, imageLink))
        }

        let collectionPreview = DispatchGroup()
        for url in cellCollection {
            let urlLink = url.imageLink
                collectionPreview.enter()
                self.networkManager.getImageByStringUrl(url: urlLink, completion: { (image, _) in
                    self.cellCollcetionData.append(image)
                    self.cellCollcetionText.append(url.text)
                    print("качнул для коллекции из урлa \(urlLink)")
                    collectionPreview.leave()
                })

        }

        collectionPreview.notify(queue: .main) {
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }

    private func setupTableView() {
        setupCykablyatMem()

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(HomeTopTableViewCell.self, forCellReuseIdentifier: "HomeTopTableViewCell")
        tableView.register(HomeSecondTableViewCell.self, forCellReuseIdentifier: "HomeSecondTableViewCell")
        tableView.register(HomeThirdTableViewCell.self, forCellReuseIdentifier: "HomeThirdTableViewCell")
        tableView.register(HomeCollectionTableviewCell.self, forCellReuseIdentifier: "HomeCollectionTableviewCell")

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = UIColor.VGDColor.clear
        tableView.keyboardDismissMode = .onDrag
        tableView.showsVerticalScrollIndicator = false

        tableView.backgroundColor = .clear
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -0)
            ])
    }

    func setupCykablyatMem() {
        titleCyka.textColor = UIColor.VGDColor.lightGray
        titleCyka.text = "CYKA"
        titleCyka.contentMode = .right
        titleCyka.font = SFMono.bold.of(size: 98)
        titleCyka.alpha = 0.1
        view.addSubview(titleCyka)
        NSLayoutConstraint.activate([
            titleCyka.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 24),
            titleCyka.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -0)
            ])
        titleBlyat.textColor = UIColor.VGDColor.lightGray
        titleBlyat.text = "BLYAT"
        titleBlyat.contentMode = .right
        titleBlyat.font = SFMono.bold.of(size: 98)
        titleBlyat.alpha = 0.1
        view.addSubview(titleBlyat)
        NSLayoutConstraint.activate([
            titleBlyat.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 24),
            titleBlyat.topAnchor.constraint(equalTo: titleCyka.bottomAnchor, constant: -32)
            ])
    }

}

// MARK: - Extensions
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {

    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numbers = 0
        if !cellTables.isEmpty {
            numbers = cellTables.count + 1
        }
        return numbers
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let text = cellTables[indexPath.row].text
            let imageLink = cellTables[indexPath.row].imageLink
            return firstCell(indexPath: indexPath, text: text, imageLink: imageLink)
        case 1:
            let text = cellTables[indexPath.row].text
            let imageLink = cellTables[indexPath.row].imageLink
            return secondCell(indexPath: indexPath, text: text, imageLink: imageLink)
        case 4:
            let rowNumber = indexPath.row
            let newIndexPath = IndexPath(row: rowNumber - 1, section: 0)
            let text = cellTables[newIndexPath.row].text
            let imageLink = cellTables[newIndexPath.row].imageLink
            return thirdCell(indexPath: newIndexPath, text: text, imageLink: imageLink)
        case 3:
            let rowNumber = indexPath.row
            let newIndexPath = IndexPath(row: rowNumber - 1, section: 0)
            let text = cellTables[newIndexPath.row].text
            let imageLink = cellTables[newIndexPath.row].imageLink
            return secondCell(indexPath: newIndexPath, text: text, imageLink: imageLink)
        case 2:
            return collectionCell(indexPath: indexPath, text: "highest rated game by Electronic Arts")
        default:
            let text = "cyka blyat"
            let imageLink = "https://steamcdn-a.akamaihd.net/steam/apps/10/0000000132.1920x1080.jpg"
            return secondCell(indexPath: indexPath, text: text, imageLink: imageLink)
        }
    }

    func firstCell(indexPath: IndexPath, text: String, imageLink: String) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTopTableViewCell", for: indexPath) as? HomeTopTableViewCell
        cell?.selectionStyle = .none
        let textUpp = text.uppercased()
        cell?.title.text = textUpp
        networkManager.getImageByStringUrl(url: imageLink, completion: { data, _ in
            guard let data = data else {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data) ?? UIImage(named: "placeholder3")
                guard let imageInCell = cell?.topImage else {
                    fatalError("тут упал и отжался")
                }
                UIView.transition(with: imageInCell, duration: 0.6, options: .transitionCrossDissolve, animations: {
                    cell?.topImage.image = image
                }, completion: nil)
            }
        })
        if let cell = cell {
            return cell
        } else {
            return defaultCell(indexPath: indexPath)
        }
    }

    func secondCell(indexPath: IndexPath, text: String, imageLink: String) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSecondTableViewCell", for: indexPath) as? HomeSecondTableViewCell
        cell?.selectionStyle = .none
        let textUpp = text.uppercased()
        cell?.title.text = textUpp
        networkManager.getImageByStringUrl(url: imageLink, completion: { data, _ in
            guard let data = data else {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data) ?? UIImage(named: "placeholder3")
                guard let imageInCell = cell?.topImage else {
                    fatalError("тут упал и отжался")
                }
                UIView.transition(with: imageInCell, duration: 0.6, options: .transitionCrossDissolve, animations: {
                    cell?.topImage.image = image
                }, completion: nil)
            }
        })
        if let cell = cell {
            return cell
        } else {
            return defaultCell(indexPath: indexPath)
        }
    }

    func thirdCell(indexPath: IndexPath, text: String, imageLink: String) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeThirdTableViewCell", for: indexPath) as? HomeThirdTableViewCell
        cell?.selectionStyle = .none
        let textUpp = text.uppercased()
        cell?.title.text = textUpp
        networkManager.getImageByStringUrl(url: imageLink, completion: { data, _ in
            guard let data = data else {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data) ?? UIImage(named: "placeholder3")
                guard let imageInCell = cell?.topImage else {
                    fatalError("тут упал и отжался")
                }
                UIView.transition(with: imageInCell, duration: 0.6, options: .transitionCrossDissolve, animations: {
                    cell?.topImage.image = image
                }, completion: nil)
            }
        })
        if let cell = cell {
            return cell
        } else {
            return defaultCell(indexPath: indexPath)
        }
    }
    func collectionCell(indexPath: IndexPath, text: String) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCollectionTableviewCell", for: indexPath) as? HomeCollectionTableviewCell

        cell?.delegate = self
        cell?.selectionStyle = .none
        cell?.cellText = cellCollcetionText
        cell?.cellImage = cellCollcetionData
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
        var newIndexPath = IndexPath(row: 0, section: 0)
        switch indexPath.row {
        case 0:
            newIndexPath = indexPath
        case 1:
            newIndexPath = indexPath
        case 4:
            let rowNumber = indexPath.row
            newIndexPath = IndexPath(row: rowNumber - 1, section: 0)
        case 3:
            let rowNumber = indexPath.row
            newIndexPath = IndexPath(row: rowNumber - 1, section: 0)
        case 2:
            print("Collection")
        default:
            print("default indexPath")
        }
        let nextViewController = GamesViewController()
        nextViewController.gameLink = preLoadDictionary?[cellTables[newIndexPath.row].text]?.next ?? ""
        nextViewController.gameListCount = preLoadDictionary?[cellTables[newIndexPath.row].text]?.count ?? 1
        nextViewController.gamesCollection = preLoadDictionary?[cellTables[newIndexPath.row].text]?.results ?? []
        nextViewController.titleScreen = cellTables[newIndexPath.row].text
        if let navigator = navigationController {
            navigator.pushViewController(nextViewController, animated: true)
        }
    }

}

extension HomeViewController: CollectionCellTapDelegate {
    func collectionCellTapped(_ numberCell: Int) {
        print("нажал на \(numberCell) ячейку")
        let nextViewController = GamesViewController()
        nextViewController.gameLink = preLoadCollection?[cellCollcetionText[numberCell]]?.next ?? ""
        nextViewController.gameListCount = preLoadCollection?[cellCollcetionText[numberCell]]?.count ?? 1
        nextViewController.gamesCollection = preLoadCollection?[cellCollcetionText[numberCell]]?.results ?? []
        nextViewController.titleScreen = cellCollcetionText[numberCell]
        if let navigator = navigationController {
            navigator.pushViewController(nextViewController, animated: true)
        }
    }
}
