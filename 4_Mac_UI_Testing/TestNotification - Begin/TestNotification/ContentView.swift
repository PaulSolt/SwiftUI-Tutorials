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
            .accessibilityIdentifier("showNotification")// TODO: Set accessibility identifiers
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ContentView()
}
