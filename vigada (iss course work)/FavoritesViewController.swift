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
    lazy var rowsToDisplay = Favorites.best.data
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
        // релоад таблицы для убирания артефактов незавершенного свайп экшена
        // своего рода костыль ;(
        tableView.reloadData()
        tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .bottom)
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
        cell?.settingView.settingNumber.text = "-//1\\-"
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
        // TODO: переход на экран с детальной информацией по игре c передачей модели для отображения
        let newViewController = GameDetailsViewController()
        if let navigator = navigationController {
            navigator.pushViewController(newViewController, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func swipeChangeCategory(category: String, indexPath: IndexPath, completion: (Bool) -> Void) {
        let currentSegment = Favorites.segmentCells.data[self.segmentedControl.selectedSegmentIndex]
        let tempVarForSwipeValue1 = self.segmentDictionary?[currentSegment]
        let tempVarForSwipeValue2 = tempVarForSwipeValue1?.filter { $0 != self.rowsToDisplay[indexPath.row] }
        self.segmentDictionary?[currentSegment] = tempVarForSwipeValue2

        var tempVarForSwipeValue = self.segmentDictionary?[category]
        tempVarForSwipeValue?.append(self.rowsToDisplay[indexPath.row])
        self.segmentDictionary?[category] = tempVarForSwipeValue

        self.rowsToDisplay.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        //self.tableView.reloadData()
        completion(true)
        // TODO: добавить метод смены категории (нормальный)
    }

    func tableView(_: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var swipeActionsConf = UISwipeActionsConfiguration(actions: [])
        var actionsArray = [UIContextualAction]()

        let currentSegment = Favorites.segmentCells.data[self.segmentedControl.selectedSegmentIndex]
        let lastSegmentAkaRecent = Favorites.segmentCells.data.last
        let swipeCell = Favorites.segmentCells.data.filter { ($0 != currentSegment) && ($0 != lastSegmentAkaRecent) }

        for cell in swipeCell {
            let action = UIContextualAction(style: .destructive, title: cell) { (_, _, completion) in
                self.swipeChangeCategory(category: cell, indexPath: indexPath, completion: completion)
            }

            switch cell {
            case Favorites.segmentCells.data[0]:
                    action.backgroundColor = UIColor.VGDColor.green
                    action.image = UIImage(named: "tabbarHeartIcon")
            case Favorites.segmentCells.data[1]:
                    action.backgroundColor = UIColor.VGDColor.yellow
                    action.image = UIImage(named: "wishes")
            case Favorites.segmentCells.data[2]:
                action.backgroundColor = UIColor.VGDColor.blue
                action.image = UIImage(named: "tabbarHomeIcon")
            default:
                action.backgroundColor = UIColor.VGDColor.yellow
                action.image = UIImage(named: "wishes")
            }
            actionsArray.append(action)
        }

        swipeActionsConf = UISwipeActionsConfiguration(actions: actionsArray)
        swipeActionsConf.performsFirstActionWithFullSwipe = false
        return swipeActionsConf
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let currentSegment = Favorites.segmentCells.data[self.segmentedControl.selectedSegmentIndex]
        if currentSegment == Favorites.segmentCells.data.last {
            let swipeActionConf = UISwipeActionsConfiguration(actions: [])
            swipeActionConf.performsFirstActionWithFullSwipe = false
            return swipeActionConf
        } else {
            let actionDelete = UIContextualAction(style: .destructive, title: "Remove from favorites") { _, _, completion in
                print("index path of delete: \(indexPath)")
                self.rowsToDisplay.remove(at: indexPath.row)
                // TODO: Позже, когда будет норм модель, переведем категорию в .none
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                completion(true)
            }
            actionDelete.backgroundColor = UIColor.VGDColor.orange

            let swipeActionConf = UISwipeActionsConfiguration(actions: [actionDelete])
            swipeActionConf.performsFirstActionWithFullSwipe = false
            return swipeActionConf
        }

    }

}

extension FavoritesViewController: CoreDataManagerDelegate {
    func loadFavoritesFromCoreData(_ segmentDictionary: [String: [String]]) {
        self.segmentDictionary = segmentDictionary
        tableView.reloadData()
    }
}
