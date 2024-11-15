//
//  PaymentCalculator.swift
//  PaymentCalculator
//
//  Created by Paul Solt on 11/15/24.
//

import SwiftUI

struct PaymentCalculator: View {
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color.blue
                    .ignoresSafeArea()
                    .frame(height: 60)
                
                VStack {
                    VStack {
                        Image(systemName: "globe")
                            .imageScale(.large)
                            .foregroundStyle(.tint)
                        Text("Hello, world!")
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
