//
//  PaymentSelector.swift
//  PaymentSelector
//
//  Created by Paul Solt on 11/15/24.
//

import SwiftUI

struct PaymentSelector: View {
    @Binding var selectedIndex: Int
    
    var paymentTerms: [PaymentTerm]
    var height: CGFloat = 60
    var lineWidth: CGFloat = 1
    var outlineColor: Color = Color(white: 0.7)
    var cornerRadius: CGFloat = 3
    
    @State var fadeLeading: Bool = false
    @State var fadeTrailing: Bool = false
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 0) {
                ForEach(paymentTerms.indices, id: \.self) { index in
                    Button {
                        selectedIndex = index
                    } label: {
                        PaymentCell(payment: paymentTerms[index], selected: selectedIndex == index)
                    }
                    
                    if index < paymentTerms.count - 1 {
                        let showDivider = selectedIndex != index && selectedIndex - 1 != index
                        Divider()
                            .frame(width: lineWidth, height: height)
                            .background(showDivider ? outlineColor : .clear)
                    }
                }
            }
        }
        .mask {
            HStack(spacing: 0) {
                LinearGradient(colors: [Color.black.opacity(fadeLeading ? 0.5 : 1), Color.black], startPoint: .leading, endPoint: .trailing)
                        .frame(width: 30)
                        .animation(.spring, value: fadeLeading)
                
                Rectangle()
                    .foregroundStyle(.black)
                
                LinearGradient(colors: [Color.black.opacity(fadeTrailing ? 0.5 : 1), Color.black], startPoint: .trailing, endPoint: .leading)
                    .frame(width: 30)
                    .foregroundStyle(.black.opacity(0.5))
                    .animation(.spring, value: fadeTrailing)
            }
        }
        .onScrollGeometryChange(for: Bool.self, of: { geometry in
            geometry.contentOffset.x > 0
        }, action: { oldValue, newValue in
            fadeLeading = newValue
        })
        .onScrollGeometryChange(for: Bool.self, of: { geometry in
            let maxOffset = geometry.contentSize.width - geometry.containerSize.width
            return geometry.contentOffset.x < maxOffset
        }, action: { oldValue, newValue in
            fadeTrailing = newValue
        })
        
        .frame(height: height)
        .cornerRadius(cornerRadius)
        .background {
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(lineWidth: lineWidth)
                .foregroundColor(outlineColor)
        }
    }
}
