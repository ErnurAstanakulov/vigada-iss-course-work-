//
//  AppDelegate.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 20.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var myOrientation: UIInterfaceOrientationMask = .portrait

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        // Если экран привествия уже смотрели, то сразу переходим на лоадер
        window?.rootViewController = LoaderViewController()
        if !UserDefaults.standard.bool(forKey: "isOnBoardSeen") {
            window?.rootViewController = OnBoardViewController()
        }
        window?.backgroundColor = UIColor.VGDColor.white
        window?.makeKeyAndVisible()
        return true
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return myOrientation
    }
}
