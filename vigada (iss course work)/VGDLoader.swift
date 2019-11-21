//
//  Utils.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 20.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

final class VGDLoader: UIView {

    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView.frame = bounds
        imageView.image = UIImage(named: "vgdLoader")
        imageView.contentMode = .scaleAspectFit
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(imageView)
    }

    required init(coder: NSCoder) {
        fatalError("VGDLoader fatal error")
    }

    enum Animation {
        case start
        case stop
    }

    func animation(_ animation: Animation) {
        switch animation {
        case .start:
            imageView.isHidden = false
            startRotate()
        case .stop:
            imageView.isHidden = true
            stopRotation()
        }
    }

    private func startRotate() {
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.imageView.layer.add(rotation, forKey: "rotationAnimation")
    }

    private func stopRotation() {
        self.imageView.layer.removeAnimation(forKey: "rotationAnimation")
    }
}

extension UIView {
    func vgdLoader(_ animation: VGDLoader.Animation) {
        let width: CGFloat = 80
        let height: CGFloat = width
        let centerX = self.frame.midX - width / 2
        let centerY = self.frame.midY - height / 2
        let vgdLoader = VGDLoader(frame: CGRect(x: centerX, y: centerY, width: width, height: height))
        if animation == .start {
            vgdLoader.tag = 100
            self.addSubview(vgdLoader)
            vgdLoader.animation(animation)
        } else {
            vgdLoader.animation(animation)
            if let viewWithTag = self.viewWithTag(100) {
                viewWithTag.removeFromSuperview()
            }
        }

    }
}
