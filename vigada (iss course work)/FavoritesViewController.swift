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
    var segmentDictionary: [String: [String]]?

    // MARK: UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Favorites"
        view.backgroundColor = .white

        coreDataManager.delegate = self

        setupUI()

        coreDataManager.loadFavoritesFromCoreData()
        if let array = segmentDictionary?["best"] {
            rowsToDisplay = array
        }
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
        let segment = Favorites.segmentCells.data[segmentedControl.selectedSegmentIndex]
        if let array = segmentDictionary?[segment] {
            rowsToDisplay = array
        } else {
            rowsToDisplay = []
        }
        // Анимация сдвига секции
        tableView.reloadData()
        //tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .bottom)
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: переход на экран с детальной информацией по игре
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func swipeChangeCategory(category: String, indexPath: IndexPath) {
        let segment = Favorites.segmentCells.data[self.segmentedControl.selectedSegmentIndex]
        let temp1 = self.segmentDictionary?[segment]
        let temp2 = temp1?.filter { $0 != self.rowsToDisplay[indexPath.row] }
        self.segmentDictionary?[segment] = temp2

        var temp = self.segmentDictionary?[category]
        temp?.append(self.rowsToDisplay[indexPath.row])
        self.segmentDictionary?[category] = temp
        self.rowsToDisplay.remove(at: indexPath.row)
        self.tableView.reloadData()
        //self.tableView.deleteRows(at: [indexPath], with: .automatic)
        // TODO: добавить метод смены категории (нормальный)
    }

    func tableView(_: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let temp = UIContextualAction(style: .normal, title: "tmp") { _, _, _ in
            print("tmp")
        }
        var conf = UISwipeActionsConfiguration(actions: [temp])

        var actionArray = [UIContextualAction]()

        let swipeCell = [Favorites.segmentCells.data[0], Favorites.segmentCells.data[1]]

        for cell in swipeCell {
            let swipe = UIContextualAction(style: .normal, title: cell) { _, _, _ in
                print(cell)
                self.swipeChangeCategory(category: cell, indexPath: indexPath)
            }

            switch cell {
            case Favorites.segmentCells.data[0]:
                    swipe.backgroundColor = UIColor.VGDColor.green
                    swipe.image = UIImage(named: "tabbarHeartIcon")
            case Favorites.segmentCells.data[1]:
                    swipe.backgroundColor = UIColor.VGDColor.yellow
                    swipe.image = UIImage(named: "wishes")
            default:
                swipe.backgroundColor = UIColor.VGDColor.yellow
                swipe.image = UIImage(named: "wishes")
            }
            actionArray.append(swipe)
        }

        conf = UISwipeActionsConfiguration(actions: actionArray)
        conf.performsFirstActionWithFullSwipe = false
        return conf
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeCell = [Favorites.segmentCells.data[2]]
        let swipeLater = UIContextualAction(style: .normal, title: swipeCell[0]) { _, _, _ in
            print(swipeCell[0])
            self.swipeChangeCategory(category: swipeCell[0], indexPath: indexPath)

        }
        swipeLater.backgroundColor = UIColor.VGDColor.blue
        swipeLater.image = UIImage(named: "tabbarHomeIcon")

        let swipeDelete = UIContextualAction(style: .destructive, title: "Remove from favorites") { _, _, _ in
            print("index path of delete: \(indexPath)")
            self.rowsToDisplay.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        swipeDelete.backgroundColor = UIColor.VGDColor.orange

        let swipeAction = UISwipeActionsConfiguration(actions: [swipeDelete, swipeLater])
        swipeAction.performsFirstActionWithFullSwipe = false
        return swipeAction
    }

}

extension FavoritesViewController: CoreDataManagerDelegate {
    func loadFavoritesFromCoreData(_ segmentDictionary: [String: [String]]) {
        self.segmentDictionary = segmentDictionary
        tableView.reloadData()
    }
}
