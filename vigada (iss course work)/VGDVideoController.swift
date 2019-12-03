//
//  VGDVideoController.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 02.12.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import AVKit

final class VGDVideoController: AVPlayerViewController {
    //расширение класса AVPlayerViewController для вращения видео в портретном режиме приложения
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        allRotateStateForDevice()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        rotateToPotraitScapeDevice()
    }

    private func allRotateStateForDevice() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.myOrientation = .all
    }

    private func rotateToPotraitScapeDevice() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.myOrientation = .portrait
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        UIView.setAnimationsEnabled(true)
    }
}
