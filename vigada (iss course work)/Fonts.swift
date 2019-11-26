//
//  Fonts.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 21.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

protocol Font {
    func of(size: CGFloat) -> UIFont?
    func of(textStyle: UIFont.TextStyle, defaultSize: CGFloat, maxSize: CGFloat?) -> UIFont?
}

enum NewYork: String, Font {
    case black = "NewYorkExtraLarge-Black"
    case bold = "NewYorkExtraLarge-Bold"
    case regular = "NewYorkExtraLarge-Regular"
    case regularItalic = "NewYorkExtraLarge-RegularItalic"
}

enum SFMono: String, Font {
    case bold = "SFMono-Bold"
    case light = "SFMono-Light"
    case regular = "SFMono-Regular"
}

enum SFCompactText: String, Font {
    case regular = "SFCompactText-Regular"
    case bold = "SFCompactText-Bold"
    case light = "SFCompactText-Light"
}

extension Font where Self: RawRepresentable, Self.RawValue == String {
    func of(size: CGFloat) -> UIFont? {
        return UIFont(name: rawValue, size: size)
    }
    func of(textStyle: UIFont.TextStyle, defaultSize: CGFloat, maxSize: CGFloat? = nil) -> UIFont? {
        guard let font = of(size: defaultSize) else {
            return nil
        }
        let fontMetrics = UIFontMetrics(forTextStyle: textStyle)

        if let maxSize = maxSize {
            return fontMetrics.scaledFont(for: font, maximumPointSize: maxSize)
        } else {
            return fontMetrics.scaledFont(for: font)
        }
    }
}
