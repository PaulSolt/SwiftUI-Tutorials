//
//  PaymentCell.swift
//  PaymentCalculator
//
//  Created by Paul Solt on 11/14/24.
//

import SwiftUI

struct PaymentCell: View {
    let payment: PaymentTerm
    let selected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(payment.months) mo")
                .foregroundStyle(selected ? .white : Colors.blue)
                .bold()
            Text("\(payment.apr, format: .percent) APR")
                .foregroundStyle(selected ? .white : Color.secondary)
                .font(.caption)
                .fontWeight(.medium)
        }
        .frame(maxHeight: .infinity)
        .padding(.horizontal, 14)
        .background(selected ? Color.blue : Color.clear)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    let term = PaymentTerm(months: 144, apr: 0.0564)
    
    HStack {
        PaymentCell(payment: term, selected: false)
        PaymentCell(payment: term, selected: true)
    }
    .frame(height: 60)
}
