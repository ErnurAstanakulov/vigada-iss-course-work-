//
//  LoaderViewController.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 20.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit
import SystemConfiguration

class LoaderViewController: UIViewController {

    private let loaderView = UIElements().containerView

    private var isInternet = true

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        guard let gifImageView = UIImageView.fromGif(frame: .zero, resourceName: "vgdLoadGIF") else {
            return
        }
        gifImageView.translatesAutoresizingMaskIntoConstraints = false
        gifImageView.contentMode = .scaleAspectFit
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

        isInternet = isConnectedToNetwork()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loaderView.vgdLoader(.start, durationIn: 1.6)
        let time = 2.5
        DispatchQueue.main.asyncAfter(deadline: .now() + time) { [weak self] in
            var newViewController: UIViewController
            self?.loaderView.vgdLoader(.stop)
            if self?.isInternet ?? false {
                newViewController = TabBarController()
            } else {
                newViewController = NoInternetViewController()
            }
            newViewController.modalTransitionStyle = .crossDissolve
            self?.present(newViewController, animated: true, completion: nil)
        }
    }

    // Проверка наличия интернета. Усли сети нет, то будуте показан специальны экран, на котором пользователь будет извещен о проблеме и ему будет предложено посмотреть сохраненные в CoreData данные.
    // Пока эта функция тут. Позже она переедет в сетевой сервис.
    // А тут, в лоадере, будет проверка сети и предзагрузка данных из сетевого каталога для первого экрана.
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags = SCNetworkReachabilityFlags()

        if let defaultRouteReachability = defaultRouteReachability {
            if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
                return false
            }
        }

        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }

}
