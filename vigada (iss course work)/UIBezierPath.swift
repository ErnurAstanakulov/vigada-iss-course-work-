//
//  UIBezierPath.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 09.12.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

func createAngularWindowPath() -> UIBezierPath {

    let screenPath = UIBezierPath()
    screenPath.move(to: CGPoint(x: 182.5, y: 55.5))
    screenPath.addLine(to: CGPoint(x: 182.5, y: 49.5))
    screenPath.addLine(to: CGPoint(x: 197.5, y: 49.5))
    screenPath.addLine(to: CGPoint(x: 197.5, y: 32.5))
    screenPath.addLine(to: CGPoint(x: 250.5, y: 32.5))
    screenPath.addLine(to: CGPoint(x: 250.5, y: 42.5))
    screenPath.addLine(to: CGPoint(x: 286.5, y: 42.5))
    screenPath.addLine(to: CGPoint(x: 286.5, y: 55.5))
    screenPath.addLine(to: CGPoint(x: 312.5, y: 55.5))
    screenPath.addLine(to: CGPoint(x: 312.5, y: 166.5))
    screenPath.addLine(to: CGPoint(x: 302.5, y: 166.5))
    screenPath.addLine(to: CGPoint(x: 302.5, y: 185.5))
    screenPath.addLine(to: CGPoint(x: 281.5, y: 185.5))
    screenPath.addLine(to: CGPoint(x: 281.5, y: 198.5))
    screenPath.addLine(to: CGPoint(x: 191.5, y: 198.5))
    screenPath.addLine(to: CGPoint(x: 191.5, y: 179.5))
    screenPath.addLine(to: CGPoint(x: 165.5, y: 179.5))
    screenPath.addLine(to: CGPoint(x: 165.5, y: 166.5))
    screenPath.addLine(to: CGPoint(x: 149.5, y: 166.5))
    screenPath.addLine(to: CGPoint(x: 149.5, y: 55.5))
    screenPath.addLine(to: CGPoint(x: 182.5, y: 55.5))
    screenPath.close()
    return screenPath
}

func createTvWindowPath() -> UIBezierPath {

    let tVScreenPathPath = UIBezierPath()
    tVScreenPathPath.move(to: CGPoint(x: 140.5, y: 152.5))
    tVScreenPathPath.addCurve(to: CGPoint(x: 263.5, y: 156.5), controlPoint1: CGPoint(x: 150.5, y: 145.5), controlPoint2: CGPoint(x: 215.5, y: 140.5))
    tVScreenPathPath.addCurve(to: CGPoint(x: 274.5, y: 182.5), controlPoint1: CGPoint(x: 275.5, y: 160.5), controlPoint2: CGPoint(x: 274.5, y: 174.5))
    tVScreenPathPath.addCurve(to: CGPoint(x: 273.5, y: 209.5), controlPoint1: CGPoint(x: 274.5, y: 193.41), controlPoint2: CGPoint(x: 273.96, y: 196.77))
    tVScreenPathPath.addCurve(to: CGPoint(x: 269.5, y: 258.5), controlPoint1: CGPoint(x: 272.61, y: 234.1), controlPoint2: CGPoint(x: 269.5, y: 258.5))
    tVScreenPathPath.addCurve(to: CGPoint(x: 263.5, y: 269.5), controlPoint1: CGPoint(x: 269.5, y: 258.5), controlPoint2: CGPoint(x: 268.5, y: 265.5))
    tVScreenPathPath.addCurve(to: CGPoint(x: 200.5, y: 277.5), controlPoint1: CGPoint(x: 258.5, y: 273.5), controlPoint2: CGPoint(x: 230.25, y: 278.5))
    tVScreenPathPath.addCurve(to: CGPoint(x: 160.5, y: 275.5), controlPoint1: CGPoint(x: 170.75, y: 276.5), controlPoint2: CGPoint(x: 170.5, y: 276.5))
    tVScreenPathPath.addCurve(to: CGPoint(x: 133.5, y: 258.5), controlPoint1: CGPoint(x: 150.5, y: 274.5), controlPoint2: CGPoint(x: 136.75, y: 274.75))
    tVScreenPathPath.addCurve(to: CGPoint(x: 128.5, y: 208.5), controlPoint1: CGPoint(x: 130.25, y: 242.25), controlPoint2: CGPoint(x: 128.5, y: 229.5))
    tVScreenPathPath.addCurve(to: CGPoint(x: 140.5, y: 152.5), controlPoint1: CGPoint(x: 128.5, y: 187.5), controlPoint2: CGPoint(x: 130.5, y: 159.5))
    tVScreenPathPath.close()

    return tVScreenPathPath
}
