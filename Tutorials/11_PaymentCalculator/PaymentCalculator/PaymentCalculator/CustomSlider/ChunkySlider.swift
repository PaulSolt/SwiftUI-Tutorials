//
//  ChunkySlider.swift
//  CustomSlider
//
//  Created by Paul Solt on 11/15/24.
//


import UIKit

class ChunkySlider: UISlider {
    var height: Double = 2
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.trackRect(forBounds: bounds)
        rect.size.height = height
        return rect
    }
}
