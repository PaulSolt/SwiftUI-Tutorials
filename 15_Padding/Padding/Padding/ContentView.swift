//
//  ContentView.swift
//  Padding
//
//  Created by Paul Solt on 3/16/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Image(systemName: "star.fill")
                .font(.system(size: 50))
                .foregroundColor(.yellow)

            Text("Welcome to SwiftUI: Learn Anything You Want to Learn Today!")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            //                .background(.orange)

            Text("""
I spent a week using ChatGPT Pro with Xcode—and it changed the way I code, but is it worth all the hype? In this video, we'll explore the new features, how they impact your workflow, and whether ChatGPT Pro truly deserves the 'Pro' title ($200/month). Is it worth the investment? Let's find out!
""")
            .font(.subheadline)
            .foregroundColor(.white)
        }
        .padding(.all, 20)
        .background(.blue.gradient)
        .cornerRadius(12)
        .padding(.horizontal, 20) // Outside padding

//        VStack {
//            VStack {
//                Image(systemName: "globe")
//                    .imageScale(.large)
//                    .foregroundStyle(.tint)
//                Text ("Hello, world!")
//            }
//            .padding()
//            .background(.green.gradient)
//            Text("More text here")
//                .font(.title)
//                .background(.blue.gradient)
//                .padding(.horizontal, 40)
//                .padding(.vertical, 40)
//                .background(.yellow.gradient)
//            Text( "Expand To the Edges")
//                .frame(maxWidth: .infinity)
//                .background(.orange)
//                .padding(40)
//        }
//    }
}



#Preview {
    ContentView()
}
