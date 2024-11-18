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
    @State var selectedIndex: Int = 2
    
    static let thumbImage = ImageHelper.createThumbnail(size: CGSize(width: 30, height: 30), tint: UIColor(Colors.thumb))
    
    var paymentTerms = [
        PaymentTerm(months: 36, apr: 0.0349),
        PaymentTerm(months: 48, apr: 0.0374),
        PaymentTerm(months: 60, apr: 0.0399),
        PaymentTerm(months: 72, apr: 0.0424),
        PaymentTerm(months: 144, apr: 0.056),
        PaymentTerm(months: 288, apr: 0.0593)
    ]
   
    let innerPadding: CGFloat = 20
    let rowPadding: CGFloat = 30
    let outerPadding: CGFloat = 20
    let cardCornerRadius: CGFloat = 4
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Colors.blue
                    .ignoresSafeArea()
                    .frame(height: 60)
                
                VStack {
                    VStack(spacing: rowPadding) {
                        loanCalculator
                            .padding(.top, outerPadding)
                                            
                        estimatedPayment
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
    
    var estimatedPayment: some View {
        HStack {
            Image("CardHero")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
            
            Spacer()
            
            VStack {
                Text("Estimated Payment")
                    .font(.title3)
                    .foregroundStyle(Colors.secondaryTitle)
                
                HStack(alignment: .firstTextBaseline) {
                    Text("\(calculatePMT(), format: .currency(code: currencyCode).precision(.fractionLength(0)))")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundStyle(Colors.blue)
                        .monospacedDigit()
                    
                    Text("/ mo")
                        .font(.headline)
                        .foregroundStyle(Colors.blue.opacity(0.8))
                }
            }
            Spacer()
        }
        .padding(.horizontal, innerPadding)
        .background {
            boxBackground
        }
    }
    
    func calculatePMT() -> Double {
        guard selectedIndex >= 0, selectedIndex < paymentTerms.count else { return 0 }
        let selectedTerm = paymentTerms[selectedIndex]
        
        let amount = max(0, loanAmount - downPayment)
        let pmt = PMTCalculator.calculate(loanAmount: amount, apr: selectedTerm.apr, months: Double(selectedTerm.months))
        return pmt
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
                    .monospacedDigit()
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
                    .monospacedDigit()
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
                Spacer()
            }
            
            PaymentSelector(selectedIndex: $selectedIndex, paymentTerms: paymentTerms)
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
