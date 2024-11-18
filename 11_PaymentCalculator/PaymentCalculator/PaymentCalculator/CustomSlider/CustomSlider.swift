//
//  CustomSlider.swift
//  CustomSlider
//
//  Created by Paul Solt on 11/15/24.
//

import SwiftUI

struct CustomSlider: UIViewRepresentable {
    typealias UIViewType = ChunkySlider
    
    @Binding var value: Double
    var range: ClosedRange<Double>
    var trackHeight: Double = 2
    var thumbImage: UIImage? /// nil == default thumbnail image
    var hideThumbImage: Bool = false
    
    class Coordinator: NSObject {
        var parent: CustomSlider
        
        init(parent: CustomSlider) {
            self.parent = parent
        }
        
        @objc func valueChanged(_ sender: UISlider) {
            parent.value = Double(sender.value)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> ChunkySlider {
        let slider = ChunkySlider(frame: .zero)
        slider.height = trackHeight
        slider.minimumValue = Float(range.lowerBound)
        slider.maximumValue = Float(range.upperBound)
        slider.value = Float(value)
        
        if let thumbImage {
            slider.setThumbImage(thumbImage, for: .normal)
        }
        
        if hideThumbImage {
            slider.thumbTintColor = .clear
        }
        
        slider.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged(_:)), for: .valueChanged)
        
        return slider
    }
    
    func updateUIView(_ uiView: ChunkySlider, context: Context) {
        uiView.value = Float(value)
    }
}

