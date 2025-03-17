//
//  ContentView.swift
//  TextField2024
//
//  Created by Paul Solt on 12/4/24.
//

import SwiftUI

struct ContentView: View {
    @State private var text = ""
    @State private var selection: TextSelection?
    
    var body: some View {
        VStack {
//            Image(systemName: "cloud")
            Rectangle()
                .frame(width: 100, height: 100)
                .foregroundStyle(.blue)
                
            HStack {
                TextField("Very long text", text: $text, axis: .horizontal)
                Spacer()
            }
            
            TextField("Very long text here", text: $text, selection: $selection)
                .onChange(of: selection) { oldValue, newValue in
                    print(getSubstrings(text: text, indices: selection?.indices))
                }
            Text("A very long string of text that might wrap or not")
                .fixedSize(horizontal: false, vertical: true) // Allows wrapping, grows in height
                .frame(maxWidth: 200)
                .padding(.bottom)

            Text("A very long string of text that might wrap or not")
                .fixedSize(horizontal: true, vertical: false) // Doesn't wrap, might clip in height
                .frame(maxWidth: 200)
            
            Text("A single line of text, too long to fit in a box.")
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: 200, height: 200)
                .border(Color.gray)
        }
    }

    
    private func getSubstrings(
        text: String, indices: TextSelection.Indices?
    ) -> [Substring] {
        var substrings = [Substring]()
        
        switch indices {
        case .multiSelection(let rangeSet):
            for range in rangeSet.ranges {
                substrings.append(text[range])
            }
        case .selection(let range):
            substrings.append(text[range])
        case .none:
            break
        case .some(_):
            break
        }
        
        return substrings
    }
}
