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

    private let segmentedContainer = UIElements().containerView
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
    lazy var rowsToDisplay = [GameModel]()
    var segmentDictionary: [String: [GameModel]]?

    let favoritsColors = UIElements().favoritesColors
    private let addFavoritesStick = AddToFavoritesStubView()

    // MARK: UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        view.backgroundColor = UIColor.VGDColor.white
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false

        coreDataManager.loadFavoritesFromCoreData(completion: { dictionary in
            DispatchQueue.main.async {
                self.segmentDictionary = nil
                let segment = Favorites.segmentCells.data[self.segmentedControl.selectedSegmentIndex]
                if let array = dictionary[segment] {
                    let allEmpty = dictionary.allSatisfy({ $0.value.isEmpty })
                    if allEmpty {
                        self.setupAddFavoritesStick()
                    } else {
                        if let viewWithTag = self.view.viewWithTag(666) {
                            viewWithTag.removeFromSuperview()
                        }
                        self.segmentDictionary = dictionary
                        let sortedArray = array.sorted(by: { $0.gameNoteCreateTime > $1.gameNoteCreateTime })
                        self.rowsToDisplay = sortedArray
                        self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                    }
                }
            }
        })
    }

    // MARK: - Set up
    private func setupUI() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FavoritesTableViewCell.self, forCellReuseIdentifier: "FavoritesTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = UIColor.VGDColor.clear

        view.addSubview(segmentedContainer)
        NSLayoutConstraint.activate([
            segmentedContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            segmentedContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            segmentedContainer.heightAnchor.constraint(equalToConstant: 44)
            ])

        segmentedContainer.addSubview(segmentedControl)
        NSLayoutConstraint.activate([
            segmentedControl.leadingAnchor.constraint(equalTo: segmentedContainer.leadingAnchor, constant: 0),
            segmentedControl.trailingAnchor.constraint(equalTo: segmentedContainer.trailingAnchor, constant: -0),
            segmentedControl.centerYAnchor.constraint(equalTo: segmentedContainer.centerYAnchor, constant: 0),
            segmentedControl.heightAnchor.constraint(equalToConstant: 28)
            ])

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
            tableView.topAnchor.constraint(equalTo: segmentedContainer.bottomAnchor, constant: 8),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -0)
            ])
    }

    func setupAddFavoritesStick() {
        addFavoritesStick.tag = 666
        addFavoritesStick.rotate(degrees: -2)
        view.addSubview(addFavoritesStick)
        NSLayoutConstraint.activate([
            addFavoritesStick.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            addFavoritesStick.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -16),
            addFavoritesStick.heightAnchor.constraint(equalToConstant: 176),
            addFavoritesStick.widthAnchor.constraint(equalToConstant: 176)
            ])
    }

    @objc fileprivate func handleSegmentChange() {
        let segment = Favorites.segmentCells.data[segmentedControl.selectedSegmentIndex]
        if let array = segmentDictionary?[segment] {
            let sortedArray = array.sorted(by: { $0.gameNoteCreateTime > $1.gameNoteCreateTime })
            rowsToDisplay = sortedArray
        } else {
            rowsToDisplay = []
        }
        self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
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
        let imageData = rowsToDisplay[indexPath.row].gameImage
        cell?.gameImageView.image = UIImage(data: imageData)
        cell?.gameTitle.text = rowsToDisplay[indexPath.row].gameTitle
        cell?.selectionStyle = .none
        if let cell = cell {
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCellreuseId", for: indexPath)
            cell.textLabel?.text = "Broke 'Settings' table row"
            return cell
        }
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextViewController = GameDetailsViewController()
        // В зависимости от наличия интеренета показываем разные представления экранов. С навбаром или без.
        if let navigator = navigationController {
            nextViewController.game = rowsToDisplay[indexPath.row]
            navigator.pushViewController(nextViewController, animated: true)
        } else {
            nextViewController.modalTransitionStyle = .crossDissolve
            nextViewController.game = rowsToDisplay[indexPath.row]
            self.present(nextViewController, animated: true, completion: nil)
        }

    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func swipeChangeCategory(category: String, indexPath: IndexPath, completion: (Bool) -> Void) {
        // обновление текущего словаря (исключаем переходящий, в другую категорию, элемент)
        let currentSegment = Favorites.segmentCells.data[self.segmentedControl.selectedSegmentIndex]
        let tempVarForSwipeValue1 = self.segmentDictionary?[currentSegment]
        let tempVarForSwipeValue2 = tempVarForSwipeValue1?.filter { $0 != self.rowsToDisplay[indexPath.row] }
        self.segmentDictionary?[currentSegment] = tempVarForSwipeValue2

        // меняем категорию у модели и добавляем в новый сегмент
        switch category {
        case Favorites.segmentCells.data[0]:
            self.rowsToDisplay[indexPath.row].gameCategory = .best
        case Favorites.segmentCells.data[1]:
            self.rowsToDisplay[indexPath.row].gameCategory = .wishes
        case Favorites.segmentCells.data[2]:
            self.rowsToDisplay[indexPath.row].gameCategory = .later
        case Favorites.segmentCells.data[3]:
            self.rowsToDisplay[indexPath.row].gameCategory = .recent
        default:
            print("чот неудачно смена категории прошла")
        }

        //  Сохраняем модель игру в кордату
        coreDataManager.saveGame(self.rowsToDisplay[indexPath.row])

        // формирование нового массива
        var tempVarForSwipeValue = self.segmentDictionary?[category]
        tempVarForSwipeValue?.append(self.rowsToDisplay[indexPath.row])
        self.segmentDictionary?[category] = tempVarForSwipeValue

        self.rowsToDisplay.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        self.tableView.reloadData()
        completion(true)
    }

    func tableView(_: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var swipeActionsConf = UISwipeActionsConfiguration(actions: [])
        var actionsArray = [UIContextualAction]()

        let currentSegment = Favorites.segmentCells.data[self.segmentedControl.selectedSegmentIndex]
        let lastSegmentAkaRecent = Favorites.segmentCells.data.last
        let swipeCell = Favorites.segmentCells.data.filter { ($0 != currentSegment) && ($0 != lastSegmentAkaRecent) }

        for cell in swipeCell {
            let action = UIContextualAction(style: .destructive, title: "") { (_, _, completion) in
                self.swipeChangeCategory(category: cell, indexPath: indexPath, completion: completion)
            }
            switch cell {
            case Favorites.segmentCells.data[0]:
                    action.backgroundColor = favoritsColors[0]
                    action.image = UIImage(named: Favorites.segmentIcons.data[0])
            case Favorites.segmentCells.data[1]:
                    action.backgroundColor = favoritsColors[1]
                    action.image = UIImage(named: Favorites.segmentIcons.data[1])
            case Favorites.segmentCells.data[2]:
                action.backgroundColor = favoritsColors[2]
                action.image = UIImage(named: Favorites.segmentIcons.data[2])
            default:
                action.backgroundColor = favoritsColors[1]
                action.image = UIImage(named: Favorites.segmentIcons.data[1])
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
            let actionDelete = UIContextualAction(style: .destructive, title: "") { _, _, completion in
                self.swipeChangeCategory(category: Favorites.segmentCells.data[3], indexPath: indexPath, completion: completion)
            }
            actionDelete.backgroundColor = favoritsColors[3]
            actionDelete.image = UIImage(named: Favorites.segmentIcons.data[3])

            let swipeActionConf = UISwipeActionsConfiguration(actions: [actionDelete])
            swipeActionConf.performsFirstActionWithFullSwipe = false
            return swipeActionConf
        }
    }

}
