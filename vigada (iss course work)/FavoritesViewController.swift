//
//  FavoritesViewController.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 20.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    // MARK: - Properties
    private let coreDataManager = CoreDataManager()

    private let tableView = UITableView(frame: .zero, style: .plain)
    private let reuseId = "UITableViewCellreuseId"

    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: Favorites.segmentCells.data)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.tintColor = UIColor.VGDColor.blue
        if let font = SFMono.regular.of(size: 14) {
             segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        }
        return segmentedControl
    }()

    // TableSource дата
    lazy var rowsToDisplay = Favorites.first.data

    // MARK: UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Favorites"
        view.backgroundColor = .white

        coreDataManager.delegate = self

        setupUI()

        coreDataManager.loadFavoritesFromCoreData()
        // TODO: настроить вид ячейки(ячеек) favorites
    }

    // MARK: - Set up
    private func setupUI() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FavoritesTableViewCell.self, forCellReuseIdentifier: "FavoritesTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = UIColor.VGDColor.clear

        view.addSubview(segmentedControl)
        NSLayoutConstraint.activate([
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            segmentedControl.heightAnchor.constraint(equalToConstant: 25)
            ])

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -0)
            ])
    }

    @objc fileprivate func handleSegmentChange() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            rowsToDisplay = Favorites.first.data
        case 1:
            rowsToDisplay = Favorites.second.data
        case 2:
            rowsToDisplay = Favorites.third.data
        case 3:
            rowsToDisplay = Favorites.fourth.data
        default:
            rowsToDisplay = Favorites.first.data
        }
        if segmentedControl.selectedSegmentIndex < 2 {
            tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .right)
        } else {
            tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .left)
        }

    }

}

// MARK: - Extensions
extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {

    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsToDisplay.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesTableViewCell", for: indexPath) as? FavoritesTableViewCell
        cell?.settingView.settingLabel.text = rowsToDisplay[indexPath.row]
        if let cell = cell {
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
            cell.textLabel?.text = "Broke 'Settings' table row"
            return cell
        }
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: переход на экран с детальной информацией по игре
    }

}

extension FavoritesViewController: CoreDataManagerDelegate {
    func loadFavoritesFromCoreData(_ segmentDictionary: [String: [String]]) {
        // TODO: распихать по сегментам
        print(segmentDictionary)
    }
}
