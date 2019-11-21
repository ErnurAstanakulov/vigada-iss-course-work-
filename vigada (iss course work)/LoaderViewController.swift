//
//  LoaderViewController.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 20.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

class LoaderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.vgdLoader(.start)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) { [weak self] in

            self?.view.vgdLoader(.stop)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) { [weak self] in

            let newViewController = TabBarController()
            newViewController.modalTransitionStyle = .crossDissolve
            self?.present(newViewController, animated: true, completion: nil)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

}
