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
    
    let sliderPercentageWidth = 0.4 // 40% label width: to keep sliders aligned

    var body: some View {
        NavigationStack {
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
                    Text("Add Photos")
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                })
                .buttonStyle(BorderedProminentButtonStyle())
                
                DatePicker("Date", selection: $date, displayedComponents: .date)
                
                Section {
                    GeometryReader { geometry in
                        HStack(spacing: 20) {
                            Text("Visible Photos")
                                .frame(width: geometry.size.width * sliderPercentageWidth, alignment: .leading)

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
                    }
                    
                    GeometryReader { geometry in
                        HStack(spacing: 20) {
                            Text("Speed")
                                .frame(width: geometry.size.width * sliderPercentageWidth, alignment: .leading)
                            
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
                    }                    
                } header: {
                    Text("Slideshow")
                }
                
                Section {
                    Button("Delete Album", role: .destructive) {
                        print("Delete Album")
                    }
                }
                
            }
            .navigationTitle("Album Settings")
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
