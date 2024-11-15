//
//  CustomNavigationBar.swift
//  PaymentCalculator
//
//  Created by Paul Solt on 11/14/24.
//

import SwiftUI

/// UI component to match the non-standard navigation bar embelishments
/// I would probably push back on design, but this was a design challenge, or I would use a UINavigationBar to customize
/// the nav bar experience, as SwiftUI does not allow for advanced customizations
struct CustomNavigationBar<Content: View>: View {
    let backgroundColor: Color
    let content: () -> Content
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea(edges: .top) // Background extends behind the notch
            
            HStack {
                Button(action: {
                    print("Back button tapped")
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .padding(.leading)
                        .bold()
                }
                
                Spacer()
                
                content()
                
                Spacer()
                
                Button(action: {
                    print("Right button tapped")
                }) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.white)
                        .padding(.trailing)
                }
                .opacity(0)
            }
            .padding(.horizontal)
        }
        .frame(maxHeight: 200)
        .layoutPriority(-1) // Make other content fill screen
    }
}

#Preview {
    CustomNavigationBar(backgroundColor: Colors.blue) {
        VStack {
            Image(systemName: "trash")
            Text("Trash Day")
        }
        .foregroundStyle(.white)
    }
}
