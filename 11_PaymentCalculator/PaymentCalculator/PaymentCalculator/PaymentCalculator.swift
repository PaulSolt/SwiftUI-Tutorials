//
//  PaymentCalculator.swift
//  PaymentCalculator
//
//  Created by Paul Solt on 11/13/24.
//

import SwiftUI

struct PaymentCalculator: View {
    @State var loanAmount: Double = 21_900
    @State var downPayment: Double = 0
    @State var selectedTerm: PaymentTerm = PaymentTerm(months: 36, apr: 0.0349)
    
    let outsidePadding: CGFloat = 20
    let innerPadding: CGFloat = 20
    
    let paymentTerms = [
        PaymentTerm(months: 36, apr: 0.0349),
        PaymentTerm(months: 48, apr: 0.0374),
        PaymentTerm(months: 60, apr: 0.0399),
        PaymentTerm(months: 72, apr: 0.0424),
        PaymentTerm(months: 144, apr: 0.0564),
    ]
    
    static let thumbImage = ImageHelper.createThumbImage(size: CGSize(width: 30, height: 30), tint: UIColor(Colors.thumb))
    
    var body: some View {
        VStack(spacing: 0) {
            customNavigationBar
            
            NavigationStack {
                VStack {
                    
                    loanCalculator
                    
                    Spacer()
                        .frame(height: 30)
                    
                    estimatedPayment
                    
                    Spacer() // Push content upwards
                }
                // Uncomment to see the navigation bar, you'll need to turn off customNavigationBar
//                .toolbarBackground(Colors.blue, for: .automatic)
//                .toolbarBackground(.visible, for: .navigationBar)
//                .toolbar {
//                    ToolbarItem(placement: .principal) {
//                        toolbarItem
//                    }
//                }
            }
        }
    }
    
    func calculatePMT() -> Double {
        let amount = max(0, loanAmount - downPayment)
        let pmt = PMTCalculator.calculate(loanAmount: amount, apr: selectedTerm.apr, months: Double(selectedTerm.months))
        return pmt
    }
    
    @ViewBuilder
    var customNavigationBar: some View {
        CustomNavigationBar(backgroundColor: Colors.blue) {
            VStack {
                Image("MLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                Text("Payment Calculator")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white)
                    .padding(.bottom)
            }
        }
    }
    
    // Alternate approach for the UI
    @ViewBuilder
    var toolbarItem: some View {
        VStack {
            Spacer()
                .frame(height: 40)
            Image("MLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            Text("Payment Calculator")
                .font(.title)
                .bold()
                .foregroundStyle(.white)
        }
        .background(
            Rectangle()
                .foregroundStyle(Colors.blue)
        )
    }
    
    @ViewBuilder
    var loanTermSelector: some View {
        VStack {
            HStack {
                Text("Loan Term & Estimated APR")
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                Spacer()
            }
            SlidingControl(options: paymentTerms, selectedTerm: $selectedTerm)
        }
    }
    
    @ViewBuilder
    var loanCalculator: some View {
        VStack {
            loanSlider
            
            downPaymentSlider
            
            loanTermSelector
        }
        .padding(outsidePadding + innerPadding) // Inset 20 + 20
        .background {
            ZStack(alignment: .top) {
                Colors.blue             // Create flow effect from nav bar
                    .frame(height: 50)
                
                boxBackground
                    .padding([.top, .horizontal], 20) // Inset box
            }
        }
    }
    
    @ViewBuilder
    var estimatedPayment: some View {
        VStack {
            HStack {
                Image("CardHero")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Estimated Payment")
                        .font(.title2)
                    
                    HStack {
                        Text("\(calculatePMT(), format: .currency(code: currencyCode).precision(.fractionLength(0)))")
                        
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .monospacedDigit()
                        Text("/ mo")
                            .font(.headline)
                    }
                    .foregroundStyle(Colors.blue)
                }
                Spacer()
            }
            .padding(.horizontal, innerPadding)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .background {
            boxBackground
        }
        .padding(.horizontal, innerPadding)
    }

    var currencyCode: String {
        Locale.current.currency?.identifier ?? "USD"
    }
    
    @ViewBuilder
    var loanSlider: some View {
        VStack {
            HStack {
                
                Text("Loan Amount")
                    .foregroundStyle(Colors.title)
                    .fontWeight(.medium)
                Spacer()
                Text("\(loanAmount, format: .currency(code: currencyCode).precision(.fractionLength(0)))")
                    .foregroundStyle(Colors.blue)
                    .bold()
            }
            CustomUISlider(value: $loanAmount, range: 0...500_000, thumbImage: Self.thumbImage, trackHeight: 12)
                .tint(Colors.main)
        }
        .padding(.bottom, 20)
    }
    
    @ViewBuilder
    var downPaymentSlider: some View {
        VStack {
            HStack {
                Text("Down Payment")
                    .foregroundStyle(Colors.title)
                    .fontWeight(.medium)
                Spacer()
                Text("\(downPayment, format: .currency(code: currencyCode).precision(.fractionLength(0)))")
                    .foregroundStyle(Colors.blue)
                    .bold()
            }
            CustomUISlider(value: $downPayment, range: 0...500_000, thumbImage: Self.thumbImage, trackHeight: 12)
                .tint(Colors.main)
        }
        .padding(.bottom, 20)
    }
    
    @ViewBuilder
    var boxBackground: some View {
        Rectangle()
            .foregroundStyle(.background)
            .cornerRadius(5)
            .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 2)
    }
}

#Preview {
    PaymentCalculator()
}
