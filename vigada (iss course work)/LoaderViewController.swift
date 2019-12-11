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

    private let networkManager = NetworkManager()

    private let apiCollectionData = APICollectionData()

    private var majorCollection = [String: (image: Data, model: VGDModelGamesRequest)]()
    private var majorCollectionTitles = [String]()
    private var majorCollectionImages = [Data]()
    private var majorTable = [String: (image: Data, model: VGDModelGamesRequest)]()
    private var majorTableTitles = [String]()
    private var majorTableImages = [Data]()

    private var browseTopCollection = [String: (image: Data, model: VGDModelGamesRequest)]()
    private var browseTopCollectionTitles = [String]()
    private var browseTopCollectionImages = [Data]()
    private var browseAgesCollection = [String: (image: Data, model: VGDModelGamesRequest)]()
    private var browseAgesCollectionTitles = [String]()
    private var browseAgesCollectionImages = [Data]()
    private var browsePlatformsCollection = [String: (image: Data, model: VGDModelGamesRequest)]()
    private var browsePlatformsCollectionTitles = [String]()
    private var browsePlatformsCollectionImages = [Data]()

    var majorLoaded = false
    var browseLoaded = true

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

    func majorLoad() {
        let group = DispatchGroup()
        let queuePreLoader = DispatchQueue(label: "com.preLoader")

        group.enter()
        queuePreLoader.async(group: group) {
            let topCellUrls = self.apiCollectionData.collectionFirstScreen()
            self.networkManager.preLoad(topCellUrls, completion: {dictionary in
                self.majorCollection = dictionary
                for element in dictionary {
                    self.majorCollectionTitles.append(element.key)
                    self.majorCollectionImages.append(element.value.image)
                }
                group.leave()
            })
        }

        group.enter()
        queuePreLoader.async(group: group) {
            let agesCellUrls = self.apiCollectionData.tableFirstScreen()
            self.networkManager.preLoad(agesCellUrls, completion: {dictionary in
                self.majorTable = dictionary
                for element in dictionary {
                    self.majorTableTitles.append(element.key)
                    self.majorTableImages.append(element.value.image)
                }
                group.leave()
            })
        }

        group.notify(queue: .main) {
            self.majorLoaded = true
        }
    }

    func navigationToHome() {
        var nextViewController: UITabBarController
        nextViewController = TabBarController()
        if let tabbarViewcontrollers = nextViewController.viewControllers {
            if let homeViewController = tabbarViewcontrollers[0].children[0] as? HomeViewController {
                homeViewController.homeMajorTable = self.majorTable
                homeViewController.homeMajorTableTitles = self.majorTableTitles
                homeViewController.homeMajorTableImages = self.majorTableImages
                homeViewController.homeMajorCollection = self.majorCollection
                homeViewController.homeMajorCollectionTitles = self.majorCollectionTitles
                homeViewController.homeMajorCollectionImages = self.majorCollectionImages

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

        // Если интернет есть, сделаем предзагрузку контента для главного экрана
        if isInternet {
            majorLoad()
            var seconds = 0
            // таймер на 1 секунду, чтобы посмотреть красивый лоадер ;)
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                seconds += 1
                if self.majorLoaded && self.browseLoaded {
                    if seconds > 2 {
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
