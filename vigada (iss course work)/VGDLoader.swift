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
        imageView.alpha = 0
    }

    required init(coder: NSCoder) {
        fatalError("VGDLoader fatal error")
    }

    enum Animation {
        case start
        case stop
    }

    func animation(_ animation: Animation, durationIn: Double, durationOut: Double) {
        switch animation {
        case .start:
            UIView.animate(withDuration: durationIn, delay: 0, options: .curveEaseInOut, animations: {
                self.imageView.alpha = 1.0
            })
            startRotate()
        case .stop:
            UIView.animate(withDuration: durationOut, delay: 0, options: .curveEaseInOut, animations: {
                self.imageView.alpha = 0.0
            })
            stopRotation()
        }
    }

    private func startRotate() {
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 4)
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
    func vgdLoader(_ animation: VGDLoader.Animation, durationIn: Double = 0.6, durationOut: Double = 0.6) {
        let vgdLoader = VGDLoader(frame: .zero)
        vgdLoader.translatesAutoresizingMaskIntoConstraints = false
        vgdLoader.contentMode = .scaleAspectFit
        if animation == .start {
            vgdLoader.tag = 100
            self.addSubview(vgdLoader)
            NSLayoutConstraint.activate([
                vgdLoader.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
                vgdLoader.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -0),
                vgdLoader.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
                vgdLoader.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
                vgdLoader.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
                vgdLoader.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
                ])
            vgdLoader.animation(animation, durationIn: durationIn, durationOut: durationOut)
        } else {
            vgdLoader.animation(animation, durationIn: durationIn, durationOut: durationOut)
            if let viewWithTag = self.viewWithTag(100) {
                viewWithTag.removeFromSuperview()
            }
        }
    }
}
