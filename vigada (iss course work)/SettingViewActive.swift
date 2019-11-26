//
//  SettingViewActive.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 26.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

final class SettingViewActive: SettingView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        settingButton.setTitleColor(UIColor.VGDColor.pink, for: .normal)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
