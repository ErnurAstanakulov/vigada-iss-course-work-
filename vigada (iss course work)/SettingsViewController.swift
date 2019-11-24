//
//  SettingsViewController.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 20.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    private let settingsView1 = SettingsView()
    private let settingsView2 = SettingsView()
    private let aboutView = AboutView()

    private let contentView = UIElements().containerView
    private let scrollView = UIElements().scrollView

    private var isAuthGithub = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .white

        setupScrollView()

        addContentView()

        setupContentView()
    }

    private func setupScrollView() {
        self.view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
            ])

        self.scrollView.delegate = self
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
    }

    private func addContentView() {
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -8),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -8),
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0)
            ])
    }

    private func setupContentView() {
        contentView.addSubview(settingsView1)
        NSLayoutConstraint.activate([
            settingsView1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            settingsView1.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            settingsView1.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24)
            ])
        contentView.addSubview(settingsView2)
        NSLayoutConstraint.activate([
            settingsView2.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            settingsView2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            settingsView2.topAnchor.constraint(equalTo: settingsView1.bottomAnchor, constant: 8)
            ])

        contentView.addSubview(aboutView)
        NSLayoutConstraint.activate([
            aboutView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            aboutView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -0),
            aboutView.topAnchor.constraint(equalTo: settingsView2.bottomAnchor, constant: 16),
            aboutView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
            ])

        settingsView1.settingNumber.text = "1."
        settingsView1.settingButton.setTitle("Have a github account? Log in", for: .normal)
        settingsView1.settingButton.addTarget(self, action: #selector(self.githubAuthButtonClicked), for: .touchUpInside)
        settingsView1.settingLabel.text = "You can keep your favorites \n& wish list there, too."
        checkGithubAuth()

        settingsView2.settingNumber.text = "2."
        settingsView2.settingButton.setTitle("Press the button and nothing happens.", for: .normal)
        settingsView2.settingButton.addTarget(self, action: #selector(self.githubAuthButtonClicked), for: .touchUpInside)
        settingsView2.settingLabel.text = "Some second setting"

        aboutView.logoImageView.image = UIImage(named: "vgdLogo")
        aboutView.vgdLabel.text = "VIDEO GAMES DATA"
        aboutView.apiLabel.text = "by API.RAWG.IO/docs"
        aboutView.workTitleLabel.text = "ISS course work"
        aboutView.authorLabel.text = "author Maxim Marchuk"
        aboutView.linkLabel.text = "https://github.com/maximmarch"
        aboutView.dateLabel.text = "2019"
    }
    // Если авторизация на гитхабе была, покажем этот вариант
    private func checkGithubAuth() {
        if checkGithubToken() {
            isAuthGithub = !isAuthGithub
            settingsView1.settingButton.isHidden = isAuthGithub
            settingsView1.settingHiddenLabel.isHidden = !isAuthGithub
            settingsView1.settingHiddenLabel.textColor = UIColor.VGDColor.pink
            settingsView1.settingHiddenLabel.font = settingsView1.settingButton.titleLabel?.font
            settingsView1.settingHiddenLabel.text = "You're already logged in github."
            settingsView1.settingLabel.text = "And now your favorites are always with you after reinstalling the app or on any devices"
            //UserDefaults.standard.removeObject(forKey: "githubToken")
        }
    }
    // Авторизируемся на гитхабе
    @objc func githubAuthButtonClicked() {
        let requestTokenViewController = GithubAuthViewController()
        requestTokenViewController.delegate = self
        present(requestTokenViewController, animated: false, completion: nil)
    }

}

extension SettingsViewController: UIScrollViewDelegate {

}

extension SettingsViewController: GithubAuthViewControllerDelegate {
    func handleTokenReceived(token: String) {
        DispatchQueue.main.async {
            // сохраняем токен
            saveGithubToken(value: token)
            // меняем элементы интерфейса
            self.checkGithubAuth()
        }
    }
}
