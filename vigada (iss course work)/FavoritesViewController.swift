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

    // MARK: UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        view.backgroundColor = .white
        coreDataManager.delegate = self
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false

        // Данные берем из кордаты каждый раз, когда приходим на экран.
        // Или только при перевоначальной инициализации экрана. Далее при смене категории от Геймдетеилс возвращаем модель
        // и тут пересортировываем словарь
        // TODO скорее всего так и надо сделать, сейчас бывает фатал эрор с рендежем индекса
        // Дальше со словарем ничего не делаем, кроме текущих изменений в настоящем представлении.
        coreDataManager.loadFavoritesFromCoreData()
        if let array = segmentDictionary?[Favorites.segmentCells.data[0]] {
            rowsToDisplay = array
        }
        // Сохраняем потом только модель индидуально при смене категории
        // отдаём её кордатаменеджеру он разберется что делать
        // ниже стоит тудушка в нужном месте
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
            segmentedControl.heightAnchor.constraint(equalToConstant: 36)
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
        tableView.reloadData()
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
        // В зависимости от налия интеренета показываем разные представления экранов. С навбаром или без.
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
        // обновление текущего
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

        // TODO: отправляем модель на сохранение в кордату
        // self.rowsToDisplay[indexPath.row] <- save to CoreData

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
                self.swipeChangeCategory(category: GameCategory.recent.rawValue, indexPath: indexPath, completion: completion)
            }
            actionDelete.backgroundColor = favoritsColors[3]
            actionDelete.image = UIImage(named: Favorites.segmentIcons.data[3])

            let swipeActionConf = UISwipeActionsConfiguration(actions: [actionDelete])
            swipeActionConf.performsFirstActionWithFullSwipe = false
            return swipeActionConf
        }
    }

}

extension FavoritesViewController: CoreDataManagerDelegate {
    func loadFavoritesFromCoreData(_ segmentDictionary: [String: [GameModel]]) {
        self.segmentDictionary = segmentDictionary
        tableView.reloadData()
    }
}
