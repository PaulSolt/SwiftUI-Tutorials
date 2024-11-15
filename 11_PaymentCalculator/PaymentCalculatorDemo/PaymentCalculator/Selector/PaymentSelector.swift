//
//  PaymentSelector.swift
//  PaymentCalculator
//
//  Created by Paul Solt on 11/14/24.
//

import SwiftUI

struct PaymentSelector: View {
    let cornerRadius: CGFloat = 5
    let color = Color(white: 0.7) //Color(UIColor.tertiaryLabel)
    
    var options: [PaymentTerm]
    
    let height: CGFloat = 60
    let lineWidth: CGFloat = 1
    
    @Binding var selectedIndex: Int

    @State var fadeLeading = false
    @State var fadeTrailing = false
    
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 0) {
                ForEach(options.indices, id: \.self) { index in
                    Button(action: {
                        selectedIndex = index
                    }) {
                        PaymentCell(payment: options[index], selected: selectedIndex == index)
                    }
                    
                    // Add a separator if it's not selected or the last item
                    if index < options.count - 1 {
                        let showDivider = selectedIndex != index && selectedIndex-1 != index
                        Divider()
                            .frame(width: lineWidth, height: height - lineWidth * 2)
                            .background(showDivider ? color : Color.clear)
                    }
                    
                }
            }
            
        }
        .mask {
            HStack(spacing: 0) {
                if fadeLeading {
                    LinearGradient(colors: [Color.white.opacity(0.5), Color.black], startPoint: .leading, endPoint: .trailing)
                        .frame(width: 30)
                        .animation(.spring, value: fadeLeading)
                        .allowsHitTesting(false)
                }
                
                Rectangle()
                    .foregroundStyle(.black)
                
                if fadeTrailing {
                    LinearGradient(colors: [Color.white.opacity(0.5), Color.black], startPoint: .trailing, endPoint: .leading)
                        .frame(width: 30)
                        .animation(.spring, value: fadeTrailing)
                        .allowsHitTesting(false)
                }
            }
        }
        .onScrollGeometryChange(for: Bool.self, of: { geometry in
            geometry.contentOffset.x > 0
        }, action: { oldValue, newValue in
            fadeLeading = newValue
        })
        .onScrollGeometryChange(for: Bool.self, of: { geometry in
            // Check if the current offset is close to the end
            let maxOffset = geometry.contentSize.width - geometry.containerSize.width
            let result = geometry.contentOffset.x <= maxOffset - 1 // Allow for a small margin
            print("maxOffset: \(maxOffset) result: \(result)")
            return result
        }, action: { oldValue, newValue in
            print("At end of content: \(newValue)")
            fadeTrailing = newValue
        })
        .frame(height: height)
        .cornerRadius(cornerRadius)
        .background {
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(lineWidth: lineWidth)
                .foregroundStyle(color)
        }
    }
}

#Preview {
    @Previewable
    @State var paymentTerms = [
        PaymentTerm(months: 36, apr: 0.0349),
        PaymentTerm(months: 48, apr: 0.0374),
        PaymentTerm(months: 60, apr: 0.0399),
        PaymentTerm(months: 72, apr: 0.0424),
        PaymentTerm(months: 144, apr: 0.0564),
    ]
    
    @Previewable
    @State var selectedIndex = 1
    
    PaymentSelector(options: paymentTerms, selectedIndex: $selectedIndex)
        .onChange(of: selectedIndex) { oldValue, newValue in
            print("Term: \(newValue) \(paymentTerms[selectedIndex])")
        }
        .padding()
}
