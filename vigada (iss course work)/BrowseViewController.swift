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

    // MARK: - UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Browse"
        view.backgroundColor = UIColor.VGDColor.white

        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

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

        tableView.backgroundColor = UIColor.VGDColor.white
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -0)
            ])
    }

    func topCollectionCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BrowseTopTableviewCell", for: indexPath) as? BrowseTopTableviewCell

        cell?.delegate = self
        cell?.selectionStyle = .none

        let cellCollcetionText = ["Test 1Test2"]
        let cellCollcetionData: [Data?] = [nil]

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

        let cellCollcetionText = ["Test 1Test 1", "Test 1Test2", "Test 1Test 1", "Test2", "Test 1", "Test2"]
        let cellCollcetionData: [Data?] = [nil, nil, nil, nil, nil, nil]

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

        let cellCollcetionText = ["Test 1Test 1", "Test 1Test2", "Test 1Test 1", "Test2", "Test 1", "Test2", "Test 1Test 1", "Test 1Test2", "Test 1Test 1", "Test2", "Test 1", "Test2"]
        let cellCollcetionData: [Data?] = [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]

        cell?.cellText = cellCollcetionText
        cell?.cellImage = cellCollcetionData
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
        print("нажал")
    }
}

extension BrowseViewController: BrowseTopTableViewCellTapDelegate {
    func topCollectionCellTapped(_ numberCell: Int) {
        print("нажал на \(numberCell) ячейку")
//        let nextViewController = GamesViewController()
//        nextViewController.gameLink = preLoadCollection?[cellCollcetionText[numberCell]]?.next ?? ""
//        nextViewController.gameListCount = preLoadCollection?[cellCollcetionText[numberCell]]?.count ?? 1
//        nextViewController.gamesCollection = preLoadCollection?[cellCollcetionText[numberCell]]?.results ?? []
//        nextViewController.titleScreen = cellCollcetionText[numberCell]
//        if let navigator = navigationController {
//            navigator.pushViewController(nextViewController, animated: true)
//        }
    }
}

extension BrowseViewController: BrowsePlatformsTableViewCellTapDelegate {
    func platformsCollectionCellTapped(_ numberCell: Int) {
        print("нажал на \(numberCell) ячейку")
        //        let nextViewController = GamesViewController()
        //        nextViewController.gameLink = preLoadCollection?[cellCollcetionText[numberCell]]?.next ?? ""
        //        nextViewController.gameListCount = preLoadCollection?[cellCollcetionText[numberCell]]?.count ?? 1
        //        nextViewController.gamesCollection = preLoadCollection?[cellCollcetionText[numberCell]]?.results ?? []
        //        nextViewController.titleScreen = cellCollcetionText[numberCell]
        //        if let navigator = navigationController {
        //            navigator.pushViewController(nextViewController, animated: true)
        //        }
    }
}

extension BrowseViewController: BrowseAgesTableViewCellTapDelegate {
    func agesCollectionCellTapped(_ numberCell: Int) {
        print("нажал на \(numberCell) ячейку")
        //        let nextViewController = GamesViewController()
        //        nextViewController.gameLink = preLoadCollection?[cellCollcetionText[numberCell]]?.next ?? ""
        //        nextViewController.gameListCount = preLoadCollection?[cellCollcetionText[numberCell]]?.count ?? 1
        //        nextViewController.gamesCollection = preLoadCollection?[cellCollcetionText[numberCell]]?.results ?? []
        //        nextViewController.titleScreen = cellCollcetionText[numberCell]
        //        if let navigator = navigationController {
        //            navigator.pushViewController(nextViewController, animated: true)
        //        }
    }
}
