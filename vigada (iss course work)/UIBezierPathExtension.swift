//
//  UIBezierPathExtension.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 09.12.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

extension CGRect {
    var center: CGPoint {
        return CGPoint( x: self.size.width/2.0, y: self.size.height/2.0)
    }
}
extension CGPoint {
    func vector(toPoint point1: CGPoint) -> CGVector {
        return CGVector(dx: point1.x-self.x, dy: point1.y-self.y)
    }
}

extension UIBezierPath {
    @discardableResult
    func moveCenter(to: CGPoint) -> Self {
        let bound  = self.cgPath.boundingBox
        let center = bounds.center

        let zeroedTo = CGPoint(x: to.x-bound.origin.x, y: to.y-bound.origin.y)
        let vector = center.vector(toPoint: zeroedTo)

        offset(to: CGSize(width: vector.dx, height: vector.dy))
        return self
    }

    @discardableResult
    func offset(to offset: CGSize) -> Self {
        let transform = CGAffineTransform(translationX: offset.width, y: offset.height)
        _ = applyCentered(transform: transform)
        return self
    }

    func fit(into: CGRect) -> Self {
        let bounds = self.cgPath.boundingBox

        let swidth = into.size.width/bounds.width
        let sheight = into.size.height/bounds.height
        let factor = min(swidth, max(sheight, 0.0))

        return scale(x: factor, y: factor)
    }
    @discardableResult func scale(x: CGFloat, y: CGFloat) -> Self {
        let scale = CGAffineTransform(scaleX: x, y: y)
        _ = applyCentered(transform: scale)
        return self
    }

    func applyCentered(transform: @autoclosure () -> CGAffineTransform ) -> Self {
        let bound  = self.cgPath.boundingBox
        let center = CGPoint(x: bound.midX, y: bound.midY)
        var xform  = CGAffineTransform.identity

        xform = xform.concatenating(CGAffineTransform(translationX: -center.x, y: -center.y))
        xform = xform.concatenating(transform())
        xform = xform.concatenating( CGAffineTransform(translationX: center.x, y: center.y))
        apply(xform)

        return self
    }
}
