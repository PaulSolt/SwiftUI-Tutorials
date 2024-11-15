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
