//
//  NoInternetViewController.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 23.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

class NoInternetViewController: UIViewController {

    private let lookStoredButton = UIElements().button
    private let gameOverTitle = UIElements().titleLabel
    private let contentView = UIElements().containerView
    private let contentLabel = UIElements().descriptionLabel
    private let pacmanGhostImageView = UIElements().imageView
    private var index = true

    override func viewDidLoad() {
        super.viewDidLoad()

        setupGameOverLabel()
        setupLookStoredButton()
        addContentView()
        addPacmanGhost()
        addContentLabel()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            UIView.animate(withDuration: 0.9, delay: 0, options: .curveEaseInOut, animations: {
                self?.contentLabel.alpha = 1.0
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) { [weak self] in
            UIView.animate(withDuration: 1.6, delay: 0, options: .curveEaseInOut, animations: {
                self?.lookStoredButton.alpha = 1.0
            })
        }

        _ = Timer.scheduledTimer(timeInterval: 0.8,
                                 target: self,
                                 selector: #selector(ghostEye),
                                 userInfo: nil,
                                 repeats: true)
        // Если пользователь ушел проверить настройки и после каких-то манипуляций, а может сам собой,
        // включился интернет, то вернувшись в приложение на этот кэран, будет снова проверка связи
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.didBecomeActiveNotification,
                                                  object: nil)
    }

    @objc func applicationDidBecomeActive() {
        print("снова проверили интернет")
        // Если он есть, то предзагрузим данные для первого экрана и перейдем на него.
    }

    @objc func ghostEye() {
        if index {
            index = !index
            pacmanGhostImageView.image = UIImage(named: "pacmanGhostAnimationSlide2")
        } else {
            index = !index
            pacmanGhostImageView.image = UIImage(named: "pacmanGhostAnimationSlide1")
        }
    }

    private func setupGameOverLabel() {
        gameOverTitle.text = "GAME OVER"
        gameOverTitle.font = NewYork.black.of(textStyle: .largeTitle, defaultSize: 34)
        self.view.addSubview(gameOverTitle)
        NSLayoutConstraint.activate([
            gameOverTitle.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            gameOverTitle.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),
            gameOverTitle.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 24),
            gameOverTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0)
            ])
    }

    private func addContentView() {
        self.view.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
            contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8),
            contentView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0),
            contentView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0)
            ])
    }

    private func addPacmanGhost() {
        pacmanGhostImageView.image = UIImage(named: "pacmanGhostAnimationSlide1")
        contentView.addSubview(pacmanGhostImageView)
        NSLayoutConstraint.activate([
            pacmanGhostImageView.heightAnchor.constraint(equalToConstant: 200),
            pacmanGhostImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            pacmanGhostImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            pacmanGhostImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            pacmanGhostImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0)
            ])
    }

    private func addContentLabel() {
        contentLabel.alpha = 0
        contentLabel.text = """
        Hahaha, no, of course not. \nThere is just no internet.
        You need to check your network settings.
        \nIn the meantime, you can see information about previously saved games.
        """
        contentView.addSubview(contentLabel)
        NSLayoutConstraint.activate([
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            contentLabel.topAnchor.constraint(equalTo: pacmanGhostImageView.bottomAnchor, constant: 8),
            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            contentLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0)
            ])
    }

    private func setupLookStoredButton() {
        lookStoredButton.setTitle("Browsing saved", for: .normal)
        self.view.addSubview(lookStoredButton)
        lookStoredButton.alpha = 0
        NSLayoutConstraint.activate([
            lookStoredButton.widthAnchor.constraint(equalToConstant: 200),
            lookStoredButton.heightAnchor.constraint(equalToConstant: 50),
            lookStoredButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            lookStoredButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
            ])
        lookStoredButton.addTarget(self, action: #selector(self.lookStoredButtonClicked), for: .touchUpInside)
    }

    // Переходим на экран с данными из CoreData
    @objc func lookStoredButtonClicked() {
//        let newViewController = LoaderViewController()
//        newViewController.modalTransitionStyle = .crossDissolve
//        self.present(newViewController, animated: true, completion: nil)
//        UserDefaults.standard.set(true, forKey: "isOnBoardSeen")
        print("click")
    }
}
