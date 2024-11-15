//
//  ImageHelper.swift
//  PaymentCalculator
//
//  Created by Paul Solt on 11/14/24.
//

import UIKit

struct ImageHelper {
    static func createThumbImage(size: CGSize, tint: UIColor) -> UIImage {
        let thumbImage = UIImage(systemName: "circle.fill")?.withTintColor(tint)
        let dotImage = thumbImage?.withTintColor(.white)
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let dotLength = size.width / 4
        let inset = dotLength + dotLength / 2
        
        let innerRect = CGRect(x: inset, y: inset, width: dotLength, height: dotLength)
        let renderer = UIGraphicsImageRenderer(size: size)
        let thumb = renderer.image { context in
            thumbImage?.draw(in: rect, blendMode: .normal, alpha: 1)
            dotImage?.draw(in: innerRect, blendMode: .normal, alpha: 1)
        }
        return thumb
    }
}
