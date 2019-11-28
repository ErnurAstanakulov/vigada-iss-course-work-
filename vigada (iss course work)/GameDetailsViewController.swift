//
//  GameDetailsViewController.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 21.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

class GameDetailsViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .plain)
    private let reuseId = "UITableViewCellreuseId"
    private let favoritesPanelLikeButtonView = FavoritesPanelLikeButtonView()

    private let containerView = UIElements().containerView
    private let containerView2 = UIElements().containerView
    private let containerView3 = UIElements().containerView

    var topConstraint = NSLayoutConstraint()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Game Title"
        view.backgroundColor = .white

        self.tabBarController?.tabBar.isHidden = true

        setupTableView()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            if let height = self?.favoritesPanelLikeButtonView.frame.size.height {
                self?.topConstraint.constant = -(height - 24)
            }
            UIView.animate(withDuration: 0.9, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self?.view.layoutIfNeeded()
                }, completion: nil)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 14) { [weak self] in
            self?.topConstraint.constant = -0
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
                self?.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    // MARK: - Set up
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: "SearchResultTableViewCell")
        tableView.register(SearchRecentTableViewCell.self, forCellReuseIdentifier: "SearchRecentTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = UIColor.VGDColor.clear

        view.addSubview(favoritesPanelLikeButtonView)
        NSLayoutConstraint.activate([
            favoritesPanelLikeButtonView.heightAnchor.constraint(equalToConstant: 152),
            favoritesPanelLikeButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            favoritesPanelLikeButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
            favoritesPanelLikeButtonView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -0)
            ])

        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 0),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
            ])
        topConstraint = containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        NSLayoutConstraint.activate([
            topConstraint
            ])

        containerView3.backgroundColor = UIColor.VGDColor.white

        let window = UIApplication.shared.windows[0]
        let safeFrame = window.safeAreaLayoutGuide.layoutFrame
        var bottomSafeAreaHeight = window.frame.maxY - safeFrame.maxY
        print(bottomSafeAreaHeight)

        containerView3.layer.cornerRadius = bottomSafeAreaHeight / 2
        if bottomSafeAreaHeight == 0 {
            bottomSafeAreaHeight = 32
            containerView3.layer.cornerRadius = 0
        }
        containerView3.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        containerView3.layer.shadowColor = UIColor.black.cgColor
        containerView3.layer.shadowRadius = 2.0
        containerView3.layer.shadowOpacity = 0.4
        containerView3.layer.shadowOffset = CGSize(width: 0, height: 3)
        containerView3.layer.masksToBounds = false

        containerView.addSubview(containerView3)
        NSLayoutConstraint.activate([
            containerView3.heightAnchor.constraint(equalToConstant: bottomSafeAreaHeight),
            containerView3.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            containerView3.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
            containerView3.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -0),
            //containerView3.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: -8),
            containerView3.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -0)
            ])

        containerView.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -0),
            tableView.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: containerView3.topAnchor, constant: 1)
            ])
    }

}

// MARK: - Extensions
extension GameDetailsViewController: UITableViewDataSource, UITableViewDelegate {

    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as? SearchResultTableViewCell
        cell?.settingView.settingLabel.text = "test"
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
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // TODO: переход на экран с детальной информацией по игре если результат
//        // или новый поиск по последним поисковым запросам (может буду хранить выдачу)
//    }

}
