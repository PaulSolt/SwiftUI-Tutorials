//
//  CustomSlider.swift
//  PaymentCalculator
//
//  Created by Paul Solt on 11/14/24.
//

import SwiftUI

struct CustomSlider: UIViewRepresentable {
    @Binding var value: Double
    var range: ClosedRange<Double>
    var thumbImage: UIImage?
    var trackHeight: CGFloat = 8
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
    
    func makeUIView(context: Context) -> UISlider {
        let slider = ChunkySlider(frame: .zero)
        slider.height = trackHeight
        slider.minimumValue = Float(range.lowerBound)
        slider.maximumValue = Float(range.upperBound)
        slider.value = Float(value)
        
        if let thumbImage = thumbImage {
            slider.setThumbImage(thumbImage, for: .normal)
        }
        
        slider.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged(_:)), for: .valueChanged)
        
        if hideThumbImage {
            slider.thumbTintColor = .clear
        }
        return slider
    }
    
    func updateUIView(_ uiView: UISlider, context: Context) {
        uiView.value = Float(value)
    }
}

#Preview {
    @Previewable
    @State var loanAmount: Double = 55_000
    let thumbnail = ImageHelper.createThumbImage(size: CGSize(width: 30, height: 30), tint: .red)
    
    let thumbnail2 = ImageHelper.createThumbImage(size: CGSize(width: 30, height: 30), tint: .black)

    Group {
        CustomSlider(value: $loanAmount, range: 0...500_000, thumbImage: thumbnail, trackHeight: 4)
            .tint(Colors.main)
        
        CustomSlider(value: $loanAmount, range: 0...500_000, thumbImage: nil, trackHeight: 4, hideThumbImage: true)
            .tint(Colors.main)
       
        CustomSlider(value: $loanAmount, range: 0...500_000, thumbImage: UIImage(systemName: "trash.fill"), trackHeight: 4, hideThumbImage: false)
            .tint(Colors.main)

        CustomSlider(value: $loanAmount, range: 0...500_000, thumbImage: thumbnail2, trackHeight: 12)
            .tint(.blue)
        
    }
    .padding()

}
