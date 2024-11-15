//
//  ChunkySlider.swift
//  PaymentCalculator
//
//  Created by Paul Solt on 11/14/24.
//


import SwiftUI

class ChunkySlider: UISlider {
    var height: Double = 2
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.trackRect(forBounds: bounds)
        rect.size.height = height
        return rect
    }
}
