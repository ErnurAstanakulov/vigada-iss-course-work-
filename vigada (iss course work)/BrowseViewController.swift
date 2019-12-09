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
        tableView.register(SearchRecentTableViewCell.self, forCellReuseIdentifier: "SearchRecentTableViewCell")
        tableView.register(BrowseTopTableviewCell.self, forCellReuseIdentifier: "BrowseTopTableviewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = UIColor.VGDColor.clear
        tableView.keyboardDismissMode = .onDrag

        tableView.backgroundColor = .yellow
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -0)
            ])
    }

    func topCollectionCell(indexPath: IndexPath, text: String) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BrowseTopTableviewCell", for: indexPath) as? BrowseTopTableviewCell

        cell?.delegate = self
        cell?.selectionStyle = .none

        let cellCollcetionText = ["Test 1", "Test2", "Test 1", "Test2", "Test 1", "Test2"]
        let cellCollcetionData: [Data?] = [nil, nil, nil, nil, nil, nil]

        cell?.cellText = cellCollcetionText
        cell?.cellImage = cellCollcetionData
        if let cell = cell {
            return cell
        } else {
            return defaultCell(indexPath: indexPath)
        }
    }

    func testCell(indexPath: IndexPath, text: String) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchRecentTableViewCell", for: indexPath) as? SearchRecentTableViewCell
        cell?.settingView.settingLabel.text = "игры..."
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
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.row {
        case 0:
            return testCell(indexPath: indexPath, text: "Какой-то текст")
        case 1:
            return topCollectionCell(indexPath: indexPath, text: "highest rated game by Electronic Arts")
        default:
            return testCell(indexPath: indexPath, text: "Какой-то текст 2")
        }
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("нажал")
    }
}

extension BrowseViewController: BrowseTopTableViewCellTapDelegate {
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
    }
}
