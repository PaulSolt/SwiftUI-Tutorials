//
//  PaymentCalculator.swift
//  PaymentCalculator
//
//  Created by Paul Solt on 11/15/24.
//

import SwiftUI



struct PaymentCalculator: View {
    @State var loanAmount: Double = 21_900
    @State var downPayment: Double = 0
    
    static let thumbImage = ImageHelper.createThumbnail(size: CGSize(width: 30, height: 30), tint: UIColor(Colors.thumb))
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Colors.blue
                    .ignoresSafeArea()
                    .frame(height: 60)
                
                VStack {
                    VStack {
                        loanCalculator
                            .padding(.top, outerPadding)
                                            
                    }
                    
                    Spacer()
                }
                .padding([.top, .horizontal], outerPadding)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        toolbarItem
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            print("Back pressed")
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundStyle(.white)
                                .bold()
                        }
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
    
    let innerPadding: CGFloat = 20
    let rowPadding: CGFloat = 30
    let outerPadding: CGFloat = 20
    let cardCornerRadius: CGFloat = 4
    
    @ViewBuilder
    var loanCalculator: some View {
        VStack(spacing: 30) {
            loanSlider
            
            downPaymentSlider
            
            loanTermSelector
        }
        .padding(.vertical, rowPadding)
        .padding(.horizontal, innerPadding)
        .background {
            boxBackground
        }
    }
    
    var loanSlider: some View {
        VStack {
            HStack {
                Text("Loan Amount")
                    .foregroundStyle(Colors.title)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text("\(loanAmount, format: .currency(code: currencyCode).precision(.fractionLength(0)))")
                    .foregroundStyle(Colors.blue)
                    .fontWeight(.bold)
            }
            
            CustomSlider(value: $loanAmount, range: 0...500_000, trackHeight: 12, thumbImage: Self.thumbImage)
                .tint(Colors.main)
        }
    }
    
    var currencyCode: String {
        Locale.current.currency?.identifier ?? "USD"
    }
    
    var downPaymentSlider: some View {
        VStack {
            HStack {
                Text("Down Payment")
                    .foregroundStyle(Colors.title)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text("\(downPayment, format: .currency(code: currencyCode).precision(.fractionLength(0)))")
                    .foregroundStyle(Colors.blue)
                    .fontWeight(.bold)
            }
            
            CustomSlider(value: $downPayment, range: 0...500_000, trackHeight: 12, thumbImage: Self.thumbImage)
                .tint(Colors.main)
        }
    }
    
    var loanTermSelector: some View {
        VStack {
            HStack {
                Text("Loan Term & Estimated APR")
                    .foregroundStyle(Colors.title)
                    .fontWeight(.medium)
//                    .frame(maxWidth: .infinity, alignment: .leading) // Force the UI to stretch out
//                    .background(.red)
                Spacer()
            }
        }
    }
    
    
    var boxBackground: some View {
        RoundedRectangle(cornerRadius: cardCornerRadius)
            .foregroundStyle(.background)
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
    
    
}

#Preview {
    PaymentCalculator()
}
