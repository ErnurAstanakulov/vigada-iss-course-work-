//
//  PlayGIF.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 22.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

extension UIImageView {
    static func fromGif(frame: CGRect, resourceName: String) -> UIImageView? {
        guard let path = Bundle.main.path(forResource: resourceName, ofType: "gif") else {
            let logger = VGDLogger(type: Error())
            logger.log(message: "Такого Gif файла нет", value: resourceName)
            return nil
        }
        let url = URL(fileURLWithPath: path)
        guard let gifData = try? Data(contentsOf: url),
            let source =  CGImageSourceCreateWithData(gifData as CFData, nil) else {
                return nil
        }
        var images = [UIImage]()
        let imageCount = CGImageSourceGetCount(source)
        for index in 0 ..< imageCount {
            if let image = CGImageSourceCreateImageAtIndex(source, index, nil) {
                images.append(UIImage(cgImage: image))
            }
        }
        let gifImageView = UIImageView(frame: frame)
        gifImageView.animationImages = images
        return gifImageView
    }
}
