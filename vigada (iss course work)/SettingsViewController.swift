//
//  SettingsViewController.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 26.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    // MARK: - Properties
    private let tableView = UITableView.init(frame: .zero, style: .plain)
    private var tableSource = [Setting]()
    private let reuseId = "UITableViewCellreuseId"
    private var isAuthGithub = false
    private let githubTokenStoreManager = GithubTokenStoreManager()

    // MARK: UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Settings"
        view.backgroundColor = UIColor.VGDColor.white

        tableViewSetup()
        tableSourceSetup()

        // хотелось бы конечно LargeTitles, но из-за них краш, про скролвью драггинг
        // wtf?
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
    }

    // MARK: - Set up
    private func tableViewSetup() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SettingNormalTableViewCell.self, forCellReuseIdentifier: "SettingNormalTableViewCell")
        tableView.register(SettingActiveTableViewCell.self, forCellReuseIdentifier: "SettingActiveTableViewCell")
        tableView.register(AboutTableViewCell.self, forCellReuseIdentifier: "AboutTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -0)
            ])

        tableView.separatorColor = UIColor.VGDColor.clear
    }

    private func tableSourceSetup() {
        var settingGuthubAccount: Setting

        if !githubTokenStoreManager.checkGithubToken() {
            settingGuthubAccount = Setting(number: "1.",
                                               buttonTitle: "Have a github account? Log in",
                                               settingTitle: "You can keep your favorites \n& wish list there, too.",
                                               status: .normal)

        } else {
            isAuthGithub = true
            settingGuthubAccount = Setting(number: "1.",
                                               buttonTitle: "You're already logged in github. \n Tap for logout.",
                                               settingTitle: "And now your favorites are always with you \nAny devices, any time.", status: .active)
        }

        let settingDemo = Setting(number: "2.",
                               buttonTitle: "Tap the button and nothing happens.",
                               settingTitle: "Some demo second setting",
                               status: .normal)
        let aboutStubSetting = Setting(number: "about",
                                       buttonTitle: "about",
                                       settingTitle: "about",
                                       status: .about)

        tableSource.append(settingGuthubAccount)
        tableSource.append(settingDemo)
        tableSource.append(aboutStubSetting)
    }

    private func isNormalCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingNormalTableViewCell", for: indexPath) as? SettingNormalTableViewCell
        cell?.settingView.settingNumber.text = tableSource[indexPath.row].number
        cell?.settingView.settingButton.setTitle(tableSource[indexPath.row].buttonTitle, for: .normal)

        cell?.settingView.settingButton.tag = indexPath.row
        cell?.settingView.settingButton.addTarget(self, action: #selector(self.settingButtonTapped(_:)), for: .touchUpInside)
        cell?.settingView.settingLabel.text = tableSource[indexPath.row].settingTitle
        if let cell = cell {
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
            cell.textLabel?.text = "Broke 'Settings' table row"
            return cell
        }
    }

    private func isActiveCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingActiveTableViewCell", for: indexPath) as? SettingActiveTableViewCell
        cell?.settingView.settingNumber.text = tableSource[indexPath.row].number
        cell?.settingView.settingButton.setTitle(tableSource[indexPath.row].buttonTitle, for: .normal)

        cell?.settingView.settingButton.tag = indexPath.row
        cell?.settingView.settingButton.addTarget(self, action: #selector(self.settingButtonTapped(_:)), for: .touchUpInside)
        cell?.settingView.settingLabel.text = tableSource[indexPath.row].settingTitle
        if let cell = cell {
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
            cell.textLabel?.text = "Broke 'Settings' table row"
            return cell
        }
    }

    private func isAboutCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutTableViewCell", for: indexPath) as? AboutTableViewCell
        cell?.aboutView.logoImageView.image = UIImage(named: "vgdLogo")
        cell?.aboutView.vgdLabel.text = "VIDEO GAMES DATA"
        cell?.aboutView.apiLabel.text = "by API.RAWG.IO/docs"
        cell?.aboutView.workTitleLabel.text = "ISS course work"
        cell?.aboutView.authorLabel.text = "author Maxim Marchuk"
        cell?.aboutView.linkLabel.text = "https://github.com/maximmarch"
        cell?.aboutView.dateLabel.text = "2019"
        if let cell = cell {
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
            cell.textLabel?.text = "Broke 'About' table row "
            return cell
        }
    }

    @objc func settingButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            if !isAuthGithub {
                githubLoginButtonTapped()
            } else {
                gihubLogoutButtonTapped()
            }
        default:
            print("press \(sender.tag)")
        }
    }

    // MARK: - GithubAuthorization call
    // Авторизируемся на гитхабе
    func githubLoginButtonTapped() {
        let requestTokenViewController = GithubAuthViewController()
        requestTokenViewController.delegate = self
        present(requestTokenViewController, animated: false, completion: nil)
    }
    func gihubLogoutButtonTapped() {
        githubTokenStoreManager.removeGithubToken()
        // Возвращаем первоначальное состояние интерфейса
        isAuthGithub = !isAuthGithub
        tableSource.removeAll()
        tableSourceSetup()
        tableView.updateRow(row: 0)
    }

}

// MARK: - Extensions
extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {

    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()

        switch tableSource[indexPath.row].status {
        case .normal:
            cell = self.isNormalCell(indexPath)
        case .active:
            cell = self.isActiveCell(indexPath)
        case .about:
            cell = self.isAboutCell(indexPath)
        }
        return cell
    }

}

extension SettingsViewController: GithubAuthViewControllerDelegate {
    func handleTokenReceived(token: String) {
        DispatchQueue.main.async {
            // сохраняем токен
            self.githubTokenStoreManager.saveGithubToken(value: token)
            // меняем элементы интерфейса
            self.tableSource.removeAll()
            self.tableSourceSetup()
            self.tableView.reloadData()
        }
    }
}

extension UITableView {
    func updateRow(row: Int, section: Int = 0) {
        let indexPath = IndexPath(row: row, section: section)
        self.beginUpdates()
        self.reloadRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.left)
        self.endUpdates()
    }
}
