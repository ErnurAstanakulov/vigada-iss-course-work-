//
//  HomeViewController.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 20.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    // MARK: - Properties

    // MARK: - UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Home"
        view.backgroundColor = .white

        let font = UIFont.preferredFont(forTextStyle: .largeTitle)
        print(font)

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 48))
        label.center = CGPoint(x: 160, y: 285)
        label.textAlignment = .center
        label.text = "See the information on the release screen"
        label.font = NewYork.black.of(textStyle: .largeTitle, defaultSize: 34)
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 34, weight: .bold)
        label.font = SFMono.regular.of(textStyle: .body, defaultSize: 20)
        label.font = SFCompactText.regular.of(textStyle: .body, defaultSize: 18)
        self.view.addSubview(label)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

    }

}
