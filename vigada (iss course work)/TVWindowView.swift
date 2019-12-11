//
//  TVWindowView.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 09.12.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

final class TVWindowView: UIView {
    override func draw(_ rect: CGRect) {
        let path = createTvWindowPath()

        let fillColor = UIColor.VGDColor.white
        fillColor.setFill()

        path.lineWidth = 1.0
        let strokeColor = UIColor.VGDColor.white
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
