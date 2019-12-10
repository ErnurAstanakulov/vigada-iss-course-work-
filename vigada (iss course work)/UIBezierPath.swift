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

func createSqPath() -> UIBezierPath {

    let sqPath = UIBezierPath()
    sqPath.move(to: CGPoint(x: 61.5, y: 32.5))
    sqPath.addCurve(to: CGPoint(x: 61.5, y: 18.5), controlPoint1: CGPoint(x: 61.5, y: 33.5), controlPoint2: CGPoint(x: 61.5, y: 18.5))
    sqPath.addLine(to: CGPoint(x: 76.5, y: 18.5))
    sqPath.addLine(to: CGPoint(x: 76.5, y: 26.5))
    sqPath.addLine(to: CGPoint(x: 100.5, y: 26.5))
    sqPath.addLine(to: CGPoint(x: 100.5, y: 11.5))
    sqPath.addLine(to: CGPoint(x: 114.5, y: 11.5))
    sqPath.addLine(to: CGPoint(x: 114.5, y: 18.5))
    sqPath.addLine(to: CGPoint(x: 129.5, y: 18.5))
    sqPath.addLine(to: CGPoint(x: 129.5, y: 26.5))
    sqPath.addLine(to: CGPoint(x: 129.5, y: 32.5))
    sqPath.addLine(to: CGPoint(x: 139.5, y: 32.5))
    sqPath.addLine(to: CGPoint(x: 139.5, y: 40.5))
    sqPath.addLine(to: CGPoint(x: 129.5, y: 40.5))
    sqPath.addLine(to: CGPoint(x: 129.5, y: 46.5))
    sqPath.addLine(to: CGPoint(x: 129.5, y: 57.5))
    sqPath.addLine(to: CGPoint(x: 148.5, y: 57.5))
    sqPath.addLine(to: CGPoint(x: 148.5, y: 72.5))
    sqPath.addLine(to: CGPoint(x: 129.5, y: 72.5))
    sqPath.addLine(to: CGPoint(x: 120.5, y: 72.5))
    sqPath.addLine(to: CGPoint(x: 120.5, y: 83.5))
    sqPath.addLine(to: CGPoint(x: 107.5, y: 83.5))
    sqPath.addLine(to: CGPoint(x: 107.5, y: 65.5))
    sqPath.addLine(to: CGPoint(x: 93.5, y: 65.5))
    sqPath.addLine(to: CGPoint(x: 93.5, y: 72.5))
    sqPath.addLine(to: CGPoint(x: 76.5, y: 72.5))
    sqPath.addLine(to: CGPoint(x: 76.5, y: 77.5))
    sqPath.addLine(to: CGPoint(x: 55.5, y: 77.5))
    sqPath.addLine(to: CGPoint(x: 55.5, y: 57.5))
    sqPath.addLine(to: CGPoint(x: 40.5, y: 57.5))
    sqPath.addLine(to: CGPoint(x: 40.5, y: 32.5))
    sqPath.addCurve(to: CGPoint(x: 61.5, y: 32.5), controlPoint1: CGPoint(x: 40.5, y: 32.5), controlPoint2: CGPoint(x: 61.5, y: 31.5))
    sqPath.close()

    return sqPath
}

func createTilePath() -> UIBezierPath {
    let tilePath = UIBezierPath()
    tilePath.move(to: CGPoint(x: 83.5, y: 58.5))
    tilePath.addCurve(to: CGPoint(x: 83.5, y: 43.5), controlPoint1: CGPoint(x: 82.5, y: 58.5), controlPoint2: CGPoint(x: 83.5, y: 43.5))
    tilePath.addLine(to: CGPoint(x: 165.5, y: 43.5))
    tilePath.addLine(to: CGPoint(x: 165.5, y: 69.5))
    tilePath.addLine(to: CGPoint(x: 183.5, y: 69.5))
    tilePath.addLine(to: CGPoint(x: 183.5, y: 90.5))
    tilePath.addLine(to: CGPoint(x: 183.5, y: 90.5))
    tilePath.addLine(to: CGPoint(x: 195.5, y: 90.5))
    tilePath.addLine(to: CGPoint(x: 195.5, y: 180.5))
    tilePath.addLine(to: CGPoint(x: 152.5, y: 180.5))
    tilePath.addLine(to: CGPoint(x: 152.5, y: 196.5))
    tilePath.addLine(to: CGPoint(x: 44.5, y: 196.5))
    tilePath.addLine(to: CGPoint(x: 44.5, y: 58.5))
    tilePath.addCurve(to: CGPoint(x: 83.5, y: 58.5), controlPoint1: CGPoint(x: 44.5, y: 58.5), controlPoint2: CGPoint(x: 84.5, y: 58.5))
    tilePath.close()

    return tilePath
}
