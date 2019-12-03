//
//  TabBarController.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 20.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    // MARK: - Life cycle
    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        // MARK: - Properties
        let homeViewController = HomeViewController()
        let browseViewController = BrowseViewController()
        let searchViewController = SearchViewController()
        let favoritesViewController = FavoritesViewController()
        let settingsViewController = SettingsViewController()

        // MARK: - Set up
        // MARK: homeNavigationController
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        navigationControllerLargeTitles(navigationController: homeNavigationController)
        homeViewController.tabBarItem.image = UIImage(named: "tabbarHomeIcon")
        homeViewController.tabBarItem.selectedImage = UIImage(named: "tabbarHomeIcon")
        homeViewController.tabBarItem.title = "TOP"
        homeViewController.tabBarItem.tag = 1

        // MARK: browseNavigationController
        let browseNavigationController = UINavigationController(rootViewController: browseViewController)
        navigationControllerLargeTitles(navigationController: browseNavigationController)
        browseNavigationController.tabBarItem.image = UIImage(named: "tabbarBrowseIcon")
        browseNavigationController.tabBarItem.selectedImage = UIImage(named: "tabbarBrowseIcon")
        browseNavigationController.tabBarItem.title = "Browse"
        browseNavigationController.tabBarItem.tag = 2

        // MARK: searchNavigationController
        let searchNavigationController = UINavigationController(rootViewController: searchViewController)
        searchViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 3)
        navigationControllerLargeTitles(navigationController: searchNavigationController)

        // MARK: favoritesNavigationController
        let favoritesNavigationController = UINavigationController(rootViewController: favoritesViewController)
        navigationControllerLargeTitles(navigationController: favoritesNavigationController)
        favoritesNavigationController.tabBarItem.image = UIImage(named: "tabbarHeartIcon")
        favoritesNavigationController.tabBarItem.selectedImage = UIImage(named: "tabbarHeartIcon")
        favoritesNavigationController.tabBarItem.title = "Favorites"
        favoritesNavigationController.tabBarItem.tag = 4

        // MARK: settingsViewController
        let settingsNavigationController = UINavigationController(rootViewController: settingsViewController)
        navigationControllerLargeTitles(navigationController: settingsNavigationController)
        settingsViewController.tabBarItem.image = UIImage(named: "tabbarSettingsIcon")
        settingsViewController.tabBarItem.selectedImage = UIImage(named: "tabbarSettingsIcon")
        settingsViewController.tabBarItem.title = "Settings"
        settingsViewController.tabBarItem.tag = 5

        // MARK: - Navigation
        viewControllers = [homeNavigationController,
                           browseNavigationController,
                           searchNavigationController,
                           favoritesNavigationController,
                           settingsNavigationController]
        tabBarControllerTitleFont()
    }

    func navigationControllerLargeTitles(navigationController: UINavigationController) {
        navigationController.navigationItem.largeTitleDisplayMode = .always
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.tintColor = UIColor.VGDColor.blue
        if let font = NewYork.black.of(size: 34) {
            navigationController.navigationBar.largeTitleTextAttributes =
                [NSAttributedString.Key.font: font]
        }
        if let font = SFCompactText.regular.of(size: 17) {
            navigationController.navigationBar.titleTextAttributes =
                [NSAttributedString.Key.font: font]
        }
        // кроме больших тайтлов, делаем навбар прозрачным
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = true
    }

    func tabBarControllerTitleFont() {
        if let font = SFCompactText.regular.of(size: 10) {
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: font], for: .selected)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
