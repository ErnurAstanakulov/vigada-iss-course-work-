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

    var homeMajorCollection = [String: (image: Data, model: VGDModelGamesRequest)]()
    var homeMajorCollectionTitles = [String]()
    var homeMajorCollectionImages = [Data]()
    var homeMajorTable = [String: (image: Data, model: VGDModelGamesRequest)]()
    var homeMajorTableTitles = [String]()
    var homeMajorTableImages = [Data]()

    // MARK: - UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Home"
        self.navigationItem.title = "VIGADA"
        view.backgroundColor = UIColor.VGDColor.white

        setupTableView()
    }

    // MARK: - Set up
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
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
            ])
    }

    private func setupCykablyatMem() {
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
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return topCell(indexPath: indexPath)
        case 1:
            return top2Cell(indexPath: indexPath)
        case 4:
            let rowNumber = indexPath.row
            let newIndexPath = IndexPath(row: rowNumber - 1, section: 0)
            return top3Cell(indexPath: newIndexPath)
        case 3:
            let rowNumber = indexPath.row
            let newIndexPath = IndexPath(row: rowNumber - 1, section: 0)
            return top2Cell(indexPath: newIndexPath)
        case 2:
            return topCollectionCell(indexPath: indexPath)
        default:
            return top2Cell(indexPath: indexPath)
        }
    }

    func topCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTopTableViewCell", for: indexPath) as? HomeTopTableViewCell
        cell?.selectionStyle = .none
        let textUpp = homeMajorTableTitles[indexPath.row].uppercased()
        cell?.title.text = textUpp
        cell?.topImage.image = UIImage(data: homeMajorTableImages[indexPath.row])
        if let cell = cell {
            return cell
        } else {
            return defaultCell(indexPath: indexPath)
        }
    }

    func top2Cell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSecondTableViewCell", for: indexPath) as? HomeSecondTableViewCell
        cell?.selectionStyle = .none
        let textUpp = homeMajorTableTitles[indexPath.row].uppercased()
        cell?.title.text = textUpp
        cell?.topImage.image = UIImage(data: homeMajorTableImages[indexPath.row])
        if let cell = cell {
            return cell
        } else {
            return defaultCell(indexPath: indexPath)
        }
    }

    func top3Cell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeThirdTableViewCell", for: indexPath) as? HomeThirdTableViewCell
        cell?.selectionStyle = .none
        let textUpp = homeMajorTableTitles[indexPath.row].uppercased()
        cell?.title.text = textUpp
        cell?.topImage.image = UIImage(data: homeMajorTableImages[indexPath.row])
        if let cell = cell {
            return cell
        } else {
            return defaultCell(indexPath: indexPath)
        }
    }

    func topCollectionCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCollectionTableviewCell", for: indexPath) as? HomeCollectionTableviewCell

        cell?.delegate = self
        cell?.selectionStyle = .none

        let cellCollcetionText = homeMajorCollectionTitles
        let cellCollcetionData: [Data] = homeMajorCollectionImages

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
        print("Нажал на строку:", newIndexPath.row)
//        let nextViewController = GamesViewController()
//        nextViewController.gameLink = preLoadDictionary?[cellTables[newIndexPath.row].text]?.next ?? ""
//        nextViewController.gameListCount = preLoadDictionary?[cellTables[newIndexPath.row].text]?.count ?? 1
//        nextViewController.gamesCollection = preLoadDictionary?[cellTables[newIndexPath.row].text]?.results ?? []
//        nextViewController.titleScreen = cellTables[newIndexPath.row].text
//        if let navigator = navigationController {
//            navigator.pushViewController(nextViewController, animated: true)
//        }
        let numberRow = newIndexPath.row
        let nextViewController = GamesViewController()
        nextViewController.gameLink = homeMajorTable[homeMajorTableTitles[numberRow]]?.model.next ?? ""
        nextViewController.gameListCount = homeMajorTable[homeMajorTableTitles[numberRow]]?.model.count ?? 1
        nextViewController.gamesCollection = homeMajorTable[homeMajorTableTitles[numberRow]]?.model.results ?? []
        nextViewController.titleScreen = homeMajorTableTitles[numberRow]
        if let navigator = navigationController {
            navigator.pushViewController(nextViewController, animated: true)
        }
    }

}

extension HomeViewController: CollectionCellTapDelegate {
    func collectionCellTapped(_ numberCell: Int) {
        print("нажал на \(numberCell) ячейку")
//        let nextViewController = GamesViewController()
//        nextViewController.gameLink = preLoadCollection?[cellCollcetionText[numberCell]]?.next ?? ""
//        nextViewController.gameListCount = preLoadCollection?[cellCollcetionText[numberCell]]?.count ?? 1
//        nextViewController.gamesCollection = preLoadCollection?[cellCollcetionText[numberCell]]?.results ?? []
//        nextViewController.titleScreen = cellCollcetionText[numberCell]
//        if let navigator = navigationController {
//            navigator.pushViewController(nextViewController, animated: true)
//        }
        let nextViewController = GamesViewController()
        nextViewController.gameLink = homeMajorCollection[homeMajorCollectionTitles[numberCell]]?.model.next ?? ""
        nextViewController.gameListCount = homeMajorCollection[homeMajorCollectionTitles[numberCell]]?.model.count ?? 1
        nextViewController.gamesCollection = homeMajorCollection[homeMajorCollectionTitles[numberCell]]?.model.results ?? []
        nextViewController.titleScreen = homeMajorCollectionTitles[numberCell]
        if let navigator = navigationController {
            navigator.pushViewController(nextViewController, animated: true)
        }
    }
}
