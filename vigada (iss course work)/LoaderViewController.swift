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

    var top70yearsRequestTitle = "top 70 years"
    var top70yearsRequest = URL(string: "")
    var best2019RequestTitle = "best 2019"
    var best2019Request = URL(string: "")
    var releaseLastMonthTitle = "Release Last Month"
    var releaseLastMonthRequest = URL(string: "")
    var mostAnticipatedUpcomingTitle = "What are the most anticipated upcoming games?"
    var mostAnticipatedUpcomingRequest = URL(string: "")

    var preLoadDictionary = [String: VGDModelGamesRequest]()

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

    func setupURLsAndTitles() {
        top70yearsRequestTitle = "top 70 years"
        top70yearsRequest = urlBuilder
            .addPath(path: .games)
            .addQuery(query: .dates, value: "1970-01-01,1979-12-31")
            .addOrderingAscending(value: .rating, order: .descending)
            .result()

        best2019RequestTitle = "best 2019"
        best2019Request = urlBuilder
            .addPath(path: .games)
            .addQuery(query: .dates, value: "2019-01-01,2019-12-31")
            .addOrderingAscending(value: .rating, order: .descending)
            .result()
        releaseLastMonthTitle = "Release Last Month"
        releaseLastMonthRequest = urlBuilder
            .addPath(path: .games)
            .addQuery(query: .dates, value: "2019-12-01,2019-12-31")
            .addOrderingAscending(value: .released, order: .descending)
            .result()

        mostAnticipatedUpcomingTitle = "What are the most anticipated upcoming games?"
        mostAnticipatedUpcomingRequest = urlBuilder
            .addPath(path: .games)
            .addQuery(query: .dates, value: "2019-12-10,2020-10-10")
            .addOrderingAscending(value: .added, order: .descending)
            .result()
    }

    func preLoadNetworkData() {

        setupURLsAndTitles()

        guard let top70yearsRequest = top70yearsRequest,
            let best2019Request = best2019Request,
            let releaseLastMonthRequest = releaseLastMonthRequest,
            let mostAnticipatedUpcomingRequest = mostAnticipatedUpcomingRequest else {
            return
        }

        let group = DispatchGroup()
        let queueRelease = DispatchQueue(label: "com.release")
        let queueBest = DispatchQueue(label: "com.best")
        let queue70 = DispatchQueue(label: "com.70")

        group.enter()
        queueRelease.async(group: group) {
            self.networkManager.getGamesList(url: top70yearsRequest, completion: { gamesList, _ in
                if let list = gamesList {
                    self.preLoadDictionary[self.top70yearsRequestTitle] = list
                }
            group.leave()
            })
        }

        group.enter()
        queueBest.async(group: group) {
            self.networkManager.getGamesList(url: best2019Request, completion: { gamesList, _ in
                if let list = gamesList {
                    self.preLoadDictionary[self.best2019RequestTitle] = list
                }
                group.leave()
            })
        }

        group.enter()
        queue70.async(group: group) {
            self.networkManager.getGamesList(url: releaseLastMonthRequest, completion: { gamesList, _ in
                if let list = gamesList {
                    self.preLoadDictionary[self.releaseLastMonthTitle] = list
                }
                group.leave()
            })
        }

        group.enter()
        queue70.async(group: group) {
            self.networkManager.getGamesList(url: mostAnticipatedUpcomingRequest, completion: { gamesList, _ in
                if let list = gamesList {
                    self.preLoadDictionary[self.mostAnticipatedUpcomingTitle] = list
                }
                group.leave()
            })
        }

        // как всё скачали переходим на главный экран
        group.notify(queue: .main) {
            self.navigationToHome()
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
            preLoadNetworkData()
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
