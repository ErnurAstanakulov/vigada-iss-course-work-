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

    var gameList: VGDModelGamesRequest?
    // MARK: - UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Home"
        self.navigationItem.title = "VIGADA"
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
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return firstCell(indexPath: indexPath, text: "popular in 2019")
        case 1:
            return secondCell(indexPath: indexPath, text: "console games were released last month")
        case 4:
            return thirdCell(indexPath: indexPath, text: "most anticipated upcoming games")
        case 3:
            return secondCell(indexPath: indexPath, text: "highest rated games from 2001")
        case 2:
            return collectionCell(indexPath: indexPath, text: "highest rated game by Electronic Arts")
        default:
            return secondCell(indexPath: indexPath, text: "cyka blyat")
        }
    }

    func firstCell(indexPath: IndexPath, text: String) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTopTableViewCell", for: indexPath) as? HomeTopTableViewCell
        cell?.selectionStyle = .none
        let textUpp = text.uppercased()
        cell?.title.text = textUpp
        //cell?.topImage.image = UIImage(named: "placeholder1")
        if let cell = cell {
            return cell
        } else {
            return defaultCell(indexPath: indexPath)
        }
    }

    func secondCell(indexPath: IndexPath, text: String) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSecondTableViewCell", for: indexPath) as? HomeSecondTableViewCell
        cell?.selectionStyle = .none
        let textUpp = text.uppercased()
        cell?.title.text = textUpp
        if let cell = cell {
            return cell
        } else {
            return defaultCell(indexPath: indexPath)
        }
    }

    func thirdCell(indexPath: IndexPath, text: String) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeThirdTableViewCell", for: indexPath) as? HomeThirdTableViewCell
        cell?.selectionStyle = .none
        let textUpp = text.uppercased()
        cell?.title.text = textUpp
        //cell?.topImage.image = UIImage(named: "placeholder1")
        if let cell = cell {
            return cell
        } else {
            return defaultCell(indexPath: indexPath)
        }
    }
    func collectionCell(indexPath: IndexPath, text: String) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCollectionTableviewCell", for: indexPath) as? HomeCollectionTableviewCell
        cell?.selectionStyle = .none
        let cellImage = ["placeholder4", "placeholder3", "placeholder2", "placeholder1", "placeholder4", "placeholder3", "placeholder2", "placeholder1"]
        let cellText = ["Cyka Blyat01", "Cyka Blyat02", "Cyka Blyat03", "Cyka Blyat04", "Cyka Blyat01", "Cyka Blyat02", "Cyka Blyat03", "Cyka Blyat04"]
        cell?.cellText = cellText
        cell?.cellImage = cellImage
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
        print("нажал")
        let nextViewController = GamesViewController()
        if let navigator = navigationController {
            navigator.pushViewController(nextViewController, animated: true)
        }
    }

}
