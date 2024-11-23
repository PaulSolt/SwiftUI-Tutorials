# CustomSlider

Wrap UISlider in UIViewRepresentable to expose it to SwiftUI.


```swift
struct CustomSlider : View {
    @State private var value : Double = 0
    init() {
        let thumbImage = UIImage(systemName: "circle.fill")
        UISlider.appearance().setThumbImage(thumbImage, for: .normal)
    }
    
    var body: some View {
        Slider(value: $value)
    }
}
```


Expanded to use a custom drawing

```swift
struct CustomSlider : View {
    @State private var value : Double = 50
    
    let thumbTintColor = Color(red: 58 / 255, green: 208 / 255, blue: 54 / 255)
    let sliderTintColor = Color(red: 185.0 / 255, green: 241.0 / 255, blue: 60.0 / 255)
    
    init() {
        let thumbImage = createThumb(size: CGSize(width: 24, height: 24), tint: UIColor(thumbTintColor))
        
        UISlider.appearance()
            .setThumbImage(thumbImage, for: .normal)
    }
    
    var body: some View {
        Slider(value: $value, in: 0...100, step: 1, onEditingChanged: { pressed in
            print(value) // Only on start/end of drag
        })
        .onChange(of: value, { oldValue, newValue in
            print(newValue) // On each drag event
        })
        .tint(sliderTintColor)
    }
    
    func createThumb(size: CGSize, tint: UIColor) -> UIImage {
        let image = UIImage(systemName: "circle.fill")!.withTintColor(tint)
        let dot = image.withTintColor(.white)
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let dotLength = size.width / 4
        let inset = size.width / 4 + dotLength / 2
        
        let innerRect = CGRect(x: inset, y: inset, width: dotLength, height: dotLength)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let thumb = renderer.image { ctx in
            image.draw(in: rect, blendMode: .normal, alpha: 1)
            ctx.cgContext.addEllipse(in: rect)
            UIColor.white.set()
            dot.draw(in: innerRect, blendMode: .normal, alpha: 1)
        }
        return thumb
    }
}
```

```swift
struct CustomUISlider: UIViewRepresentable {
    @Binding var value: Double
    var range: ClosedRange<Double>
    var thumbImage: UIImage?
    var trackHeight: CGFloat = 8

    class Coordinator: NSObject {
        var parent: CustomUISlider

        init(parent: CustomUISlider) {
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
        let slider = UISlider(frame: .zero)
        slider.minimumValue = Float(range.lowerBound)
        slider.maximumValue = Float(range.upperBound)
        slider.value = Float(value)

        // Customize the thumb image
        if let thumbImage = thumbImage {
            slider.setThumbImage(thumbImage, for: .normal)
        }

        // Set a target-action for value changes
        slider.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged(_:)), for: .valueChanged)

        // Customize the track height using a transform
        slider.transform = CGAffineTransform(scaleX: 1, y: trackHeight / 8)

        return slider
    }

    func updateUIView(_ uiView: UISlider, context: Context) {
        uiView.value = Float(value)
    }
}


```