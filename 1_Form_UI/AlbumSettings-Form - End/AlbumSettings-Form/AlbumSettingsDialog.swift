//
//  AlbumSettingsDialog.swift
//  AlbumSettings-Form
//
//  Created by Paul Solt on 4/29/24.
//

import SwiftUI

struct AlbumSettingsDialog: View {
    
    // 1. Blocking the UI: Make it look like we want, but it won't be perfect
    // 2. Tweak it
    // 3. Connect it to logic
    
    // Run Preview: Control + Option + P
    // Show/Hide Canvas (Preview): Control + Option + Enter
    // Run the app: Command + R
    // Simulator Software Keyboard: Command + K
    
    @State var title: String = ""
    @State var maxPhotosOnTable: Double = 5
    @State var slideshowSpeed: Double = 0.5
    @State var date: Date = Date() // now
    
    var body: some View {
        Form { // VStack
            TextField(text: $title, prompt: Text("Title")) {
                Text("Title")
            }
            .onSubmit {
                print("Title: \(title)")
            }
            
            ManageAlbumRow(heroImage: UIImage(systemName: "photo.on.rectangle.angled")!, count: 27, action: {
                print("Manage Photos Pressed")
            })
            
            Button(action: {
                print("Add Photos Pressed")
            }, label: {
                ZStack {
                    // Bottom layer
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(.blue)
                    Text("Add Photos")
                        .foregroundStyle(.white)
                    // Top layer
                }
            })
            
            HStack(spacing: 20) {
                Text("Slideshow Images")
                Slider(value: $maxPhotosOnTable, in: 1...10) {
                    Text("\(Int(maxPhotosOnTable))")
                } minimumValueLabel: {
                    Text("1")
                } maximumValueLabel: {
                    Text("10")
                } onEditingChanged: { changed in
                    print("maxPhotosOnTable: \(maxPhotosOnTable) changed: \(changed)")
                }
            }

            HStack(spacing: 20) {
                Text("Slideshow Speed")
                Slider(value: $slideshowSpeed, in: 0...1) {
                    Text("\(Int(slideshowSpeed))")
                } minimumValueLabel: {
                    Text("Slow")
                } maximumValueLabel: {
                    Text("Fast")
                } onEditingChanged: { changed in
                    print("speed: \(maxPhotosOnTable) changed: \(changed)")
                }
            }
            
            DatePicker("Date", selection: $date, displayedComponents: .date)
            
            Button("Delete Album", role: .destructive) {
                print("Delete Album")
            }
        }
    }
}

// ManageAlbumRow [Image, Text, <=== Spacer ===>, Text, Image]

struct ManageAlbumRow: View {
    var heroImage: UIImage = UIImage(systemName: "photo.on.rectangle.angled")! // RISKY: Not safe for user content
    var count: Int = 27
    var action: () -> Void
    
    init(heroImage: UIImage, count: Int, action: @escaping () -> Void) {
        self.heroImage = heroImage
        self.count = count
        self.action = action
    }
    
    var body: some View {
        Button(action: action, label: {
            HStack {
                Image(uiImage: heroImage)
                Text("Manage Album")
                Spacer()
                Group {
                    Text("(\(count))")
                    Image(systemName: "chevron.right")
                }
                .foregroundStyle(.gray)
            }
        })
    }
}


#Preview {
    AlbumSettingsDialog()
}
