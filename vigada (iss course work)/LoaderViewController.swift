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
    private var isInternet = true

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let networkManager = NetworkManager()
        networkManager.delegate = self
        // Проверяем есть интернет или нет.
        networkManager.checkInternet()

        setupLoaderScreen()

        self.loaderView.vgdLoader(.start, durationIn: 1.6)
        let time = 2.5
        DispatchQueue.main.asyncAfter(deadline: .now() + time) { [weak self] in
            var newViewController: UIViewController
            if let viewWithTag = self?.view.viewWithTag(42) {
                viewWithTag.removeFromSuperview()
            } else {
                print("Гифка загрузки не удалилась с вью")
            }
            self?.loaderView.vgdLoader(.stop)
            // Если интернета нет, то будем смотреть данные из базы
            if self?.isInternet ?? false {
                newViewController = TabBarController()
            } else {
                newViewController = NoInternetViewController()
            }
            newViewController.modalTransitionStyle = .crossDissolve
            self?.present(newViewController, animated: true, completion: nil)
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
        self.isInternet = isInternet

        // Если интернет есть, сделаем предзагрузку контента
        if isInternet {
            //TODO: Добавить вызов метода предзагрузки контента из сети
        }
    }
}
