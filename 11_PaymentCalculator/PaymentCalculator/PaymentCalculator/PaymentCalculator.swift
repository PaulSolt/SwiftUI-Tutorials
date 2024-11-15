//
//  PaymentCalculator.swift
//  PaymentCalculator
//
//  Created by Paul Solt on 11/15/24.
//

import SwiftUI

struct PaymentCalculator: View {
    @State var loanAmount: Double = 21_900
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color.blue
                    .ignoresSafeArea()
                    .frame(height: 60)
                
                VStack {
                    VStack {
                        Slider(value: $loanAmount, in: 0...100_000)
                            .tint(Color.red)
                        
                        CustomSlider(value: $loanAmount, range: 0...100_000, trackHeight: 8, thumbImage: ImageHelper.createThumbnail(size: CGSize(width: 30, height: 30), tint: .orange))
                            .tint(Color.yellow)

                    }
                    .background(.white)
                    
                    Spacer()
                }
                .padding()
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        toolbarItem
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    var toolbarItem: some View {
        VStack {
            Spacer()
                .frame(height: 50)
            Image("MLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
            Text("Payment Calculator")
                .font(.title)
                .bold()
                .foregroundStyle(.white)
        }
    }
    
}

#Preview {
    PaymentCalculator()
}
