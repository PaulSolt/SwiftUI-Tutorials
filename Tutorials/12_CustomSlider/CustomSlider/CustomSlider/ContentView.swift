//
//  ContentView.swift
//  CustomSlider
//
//  Created by Paul Solt on 11/15/24.
//

import SwiftUI

struct ContentView: View {
    @State var loanAmount: Double = 21_900
    
    var body: some View {
        VStack {
            CustomSlider(value: $loanAmount, range: 0...500_000, trackHeight: 1)
            
            CustomSlider(value: $loanAmount, range: 0...500_000, trackHeight: 6)
            
            CustomSlider(value: $loanAmount, range: 0...500_000, trackHeight: 10)
            
            
            CustomSlider(value: $loanAmount, range: 0...500_000, trackHeight: 10, thumbImage: nil, hideThumbImage: true)
                .tint(.red)
            
            CustomSlider(value: $loanAmount, range: 0...500_000, trackHeight: 10, thumbImage: ImageHelper.createThumbnail(size: CGSize(width: 30, height: 30), tint: .orange), hideThumbImage: false)
                .tint(.yellow)

            
            CustomSlider(value: $loanAmount, range: 0...500_000, trackHeight: 10, thumbImage: UIImage(systemName: "trash.fill"))
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
