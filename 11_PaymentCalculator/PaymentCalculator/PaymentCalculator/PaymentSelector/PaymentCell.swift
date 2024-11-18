//
//  PaymentCell.swift
//  PaymentSelector
//
//  Created by Paul Solt on 11/15/24.
//

import SwiftUI

struct PaymentCell: View {
    let payment: PaymentTerm
    let selected: Bool
    
    var body: some View {
        VStack {
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
        .background(selected ? Colors.blue : .clear)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    HStack {
        PaymentCell(payment: PaymentTerm(months: 36, apr: 0.0349), selected: true)
        PaymentCell(payment: PaymentTerm(months: 48, apr: 0.0374), selected: false)
    }
    .frame(height: 60)
}
