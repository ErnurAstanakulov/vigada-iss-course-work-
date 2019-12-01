//
//  LoaderViewController.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 20.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

class LoaderViewController: UIViewController {
    // MARK: - Properties
    private let loaderView = UIElements().containerView
    private var isInternet = "isInternet"

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let networkManager = NetworkManager()
        networkManager.delegate = self
        // Проверяем есть интернет или нет.
        networkManager.checkInternet()

        setupLoaderScreen()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loaderView.tag = 99
        self.loaderView.vgdLoader(.start, durationIn: 1.6)
        let time = 2.5
        DispatchQueue.main.asyncAfter(deadline: .now() + time) { [] in
            var nextViewController: UIViewController
            if let viewWithTag = self.view.viewWithTag(42) {
                viewWithTag.removeFromSuperview()
            } else {
                print("Гифка загрузки не удалилась с вью")
            }
            self.loaderView.vgdLoader(.stop)
            if let viewWithTag = self.view.viewWithTag(99) {
                viewWithTag.removeFromSuperview()
            } else {
                print("Колесо загрузки не удалилось с вью")
            }
            // Если интернета нет, то будем смотреть данные из базы
            let connection = UserDefaults.standard.bool(forKey: self.isInternet)
            if connection {
                nextViewController = TabBarController()
            } else {
                nextViewController = NoInternetViewController()
            }
            nextViewController.modalTransitionStyle = .crossDissolve
            self.present(nextViewController, animated: true, completion: nil)
        }
    }

    // MARK: - Set up
    func setupLoaderScreen() {
        guard let gifImageView = UIImageView.fromGif(frame: .zero, resourceName: "vgdLoadGIF") else {
            return
        }
        gifImageView.translatesAutoresizingMaskIntoConstraints = false
        gifImageView.contentMode = .scaleAspectFit
        gifImageView.tag = 42
        view.addSubview(gifImageView)
        NSLayoutConstraint.activate([
            gifImageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            gifImageView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            gifImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -64)
            ])
        gifImageView.startAnimating()

        view.addSubview(loaderView)
        NSLayoutConstraint.activate([
            loaderView.topAnchor.constraint(equalTo: gifImageView.bottomAnchor, constant: 8),
            loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            loaderView.widthAnchor.constraint(equalToConstant: 60),
            loaderView.heightAnchor.constraint(equalToConstant: 60)
            ])
    }

}

// MARK: - Extensions
extension LoaderViewController: CheckInternetDelegate {
    func checkInternet(_ isInternet: Bool) {
        UserDefaults.standard.set(isInternet, forKey: self.isInternet)

        // Если интернет есть, сделаем предзагрузку контента
        if isInternet {
            //UserDefaults.standard.set(true, forKey: "isInternet")
            //TODO: Добавить вызов метода предзагрузки контента из сети
        } else {
            //UserDefaults.standard.set(false, forKey: "isInternet")
        }
    }
}
