//
//  ContentView.swift
//  PaymentSelector
//
//  Created by Paul Solt on 11/15/24.
//

import SwiftUI

struct ContentView: View {
    @State var selectedIndex: Int = 2
    var paymentTerms = [
        PaymentTerm(months: 36, apr: 0.0349),
        PaymentTerm(months: 48, apr: 0.0374),
        PaymentTerm(months: 60, apr: 0.0399),
        PaymentTerm(months: 72, apr: 0.0424),
        PaymentTerm(months: 144, apr: 0.056),
        PaymentTerm(months: 288, apr: 0.0593)
    ]
    
    var body: some View {
        PaymentSelector(selectedIndex: $selectedIndex, paymentTerms: paymentTerms)
            .padding()
            .onChange(of: selectedIndex) { oldValue, newValue in
                print("Selected: \(newValue)")
            }
    }
}

#Preview {
    ContentView()
}
