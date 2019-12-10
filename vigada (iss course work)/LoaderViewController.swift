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
    let urlBuilder = URLBuilder()
    let networkManager = NetworkManager()

    let apiCollectionData = APICollectionData()
    let preLoader = PreLoader()

    var preLoadDictionary = [String: VGDModelGamesRequest]()
    var preLoadCollection = [String: VGDModelGamesRequest]()

    var loaded = true

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.VGDColor.white

        networkManager.delegate = self
        // Проверяем есть интернет или нет.
        networkManager.checkInternet()

        setupLoaderScreen()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loaderView.tag = 99
        self.loaderView.vgdLoader(.start, durationIn: 1.6)
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

    func preLoadNetworkData() {

        let group = DispatchGroup()
        let queuePreLoader = DispatchQueue(label: "com.preLoader")
        //let queueBest = DispatchQueue(label: "com.best")

        let tableFirstScreenData = apiCollectionData.tableFirstScreen()
        let collectionFirstScreenData = apiCollectionData.collectionFirstScreen()

        group.enter()
        queuePreLoader.async(group: group) {
            self.preLoader.preLoadDictionary(title: tableFirstScreenData.titles,
                                             urls: tableFirstScreenData.urls,
                                             completion: { tableDictionary in
                self.preLoadDictionary = tableDictionary
                group.leave()
            })
        }

        group.enter()
        queuePreLoader.async(group: group) {
            self.preLoader.preLoadDictionary(title: collectionFirstScreenData.titles,
                                             urls: collectionFirstScreenData.urls,
                                             completion: { tableDictionary in
                                                self.preLoadCollection = tableDictionary
                                                group.leave()
            })
        }

        // как всё скачали переходим на главный экран
        group.notify(queue: .main) {
            self.loaded = true
        }
    }

    func navigationToHome() {
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
        var nextViewController: UITabBarController

        nextViewController = TabBarController()
        if let tabbarViewcontrollers = nextViewController.viewControllers {
            if let homeViewController = tabbarViewcontrollers[0].children[0] as? HomeViewController {
                homeViewController.preLoadDictionary = self.preLoadDictionary
                homeViewController.preLoadCollection = self.preLoadCollection
            }
        }
        nextViewController.modalTransitionStyle = .crossDissolve
        self.present(nextViewController, animated: true, completion: nil)
    }

}

// MARK: - Extensions
extension LoaderViewController: CheckInternetDelegate {
    func checkInternet(_ isInternet: Bool) {
        UserDefaults.standard.set(isInternet, forKey: self.isInternet)

        // Если интернет есть, сделаем предзагрузку контента
        if isInternet {
            //preLoadNetworkData()
            var seconds = 0
            // таймер на 2 секунды, чтобы посмотреть красивый лоадер ;)
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                seconds += 1
                if self.loaded {
                    if seconds > 2 {
                        self.navigationToHome()
                        timer.invalidate()
                    }
                }
            }

        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [] in
                self.loaderView.vgdLoader(.stop)
                var nextViewController: UIViewController
                nextViewController = NoInternetViewController()
                nextViewController.modalTransitionStyle = .crossDissolve
                self.present(nextViewController, animated: true, completion: nil)
            }
        }
    }
}
