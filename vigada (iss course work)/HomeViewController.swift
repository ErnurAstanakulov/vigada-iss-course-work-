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

    typealias CellTuples = (text: String, imageLink: String)
    var cell = [CellTuples]()

    // MARK: - UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Home"
        self.navigationItem.title = "VIGADA"
        view.backgroundColor = UIColor.VGDColor.white

        setupTableView()

        guard let preLoadDictionary = preLoadDictionary else {
            return
        }

        for element in preLoadDictionary {
            let range = element.value.results?.count ?? 2
            let randomInt = Int.random(in: 1...range)
            let title = element.key
            guard let imageLink = element.value.results?[randomInt].backgroundImage else {
                return
            }
            cell.append((title, imageLink))
        }
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
        return cell.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(cell)
        switch indexPath.row {
        case 0:
            let text = cell[indexPath.row].text
            let imageLink = cell[indexPath.row].imageLink
            return firstCell(indexPath: indexPath, text: text, imageLink: imageLink)
        case 1:
            let text = cell[indexPath.row].text
            let imageLink = cell[indexPath.row].imageLink
            return secondCell(indexPath: indexPath, text: text, imageLink: imageLink)
        case 2:
            let text = cell[indexPath.row].text
            let imageLink = cell[indexPath.row].imageLink
            return thirdCell(indexPath: indexPath, text: text, imageLink: imageLink)
        case 3:
            let text = cell[indexPath.row].text
            let imageLink = cell[indexPath.row].imageLink
            return secondCell(indexPath: indexPath, text: text, imageLink: imageLink)
        case 4:
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
        nextViewController.gameLink = preLoadDictionary?[cell[indexPath.row].text]?.next ?? ""
        nextViewController.gameListCount = preLoadDictionary?[cell[indexPath.row].text]?.count ?? 1
        nextViewController.gamesCollection = preLoadDictionary?[cell[indexPath.row].text]?.results ?? []
        nextViewController.titleScreen = cell[indexPath.row].text
        if let navigator = navigationController {
            navigator.pushViewController(nextViewController, animated: true)
        }
    }

}
