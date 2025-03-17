//
//  PaddingExampleView.swift
//  Padding
//
//  Created by Paul Solt on 3/16/25.
//


import SwiftUI

struct PaddingExampleView: View {
    var body: some View {
        VStack(spacing: 16) {
            
            // Basic padding example
            Text("Basic Padding")
                .padding()
                .background(Color.green.opacity(0.3))

            // Custom padding amount
            Text("Custom Padding Amount")
                .padding(20)
                .background(Color.blue.opacity(0.3))

            // Horizontal and vertical padding separately (order matters!)
            Text("Horizontal & Vertical Padding")
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.orange.opacity(0.3))
                .padding(.horizontal, 24)
                .background(Color.orange.opacity(0.3))

            // Padding with other modifiers
            Text("Modifiers & Padding Order")
                .padding()
                .background(Color.purple)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .font(.headline)
    }
}

#Preview {
    PaddingExampleView()
}
