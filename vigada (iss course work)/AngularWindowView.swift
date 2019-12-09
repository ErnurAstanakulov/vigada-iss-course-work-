//
//  AngularWindowView.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 09.12.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

class AngularWindowView: UIView {
    override func draw(_ rect: CGRect) {
        let path = createAngularWindowPath()

        let fillColor = UIColor.VGDColor.white
        fillColor.setFill()

        path.lineWidth = 1.0
        let strokeColor = UIColor.VGDColor.blue
        strokeColor.setStroke()

        path.fit(into: rect).moveCenter(to: rect.center).fill()
        path.stroke()

        layer.mask = nil
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
        clipsToBounds = true
    }
}
