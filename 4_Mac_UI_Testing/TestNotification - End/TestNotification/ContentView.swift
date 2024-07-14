//
//  ContentView.swift
//  TestNotification
//
//  Created by Paul Solt on 6/6/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Button("Show Full Screen Notification") {
                FullScreenNotification.showNotification()
            }
            .padding()
            .accessibilityIdentifier("showNotification")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ContentView()
}
