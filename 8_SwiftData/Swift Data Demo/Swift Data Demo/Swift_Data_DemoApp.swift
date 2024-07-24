//
//  Swift_Data_DemoApp.swift
//  Swift Data Demo
//
//  Created by Paul Solt on 7/24/24.
//

import SwiftUI
import SwiftData

@main
struct Swift_Data_DemoApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            CoffeeRecipe.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            let modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            modelContainer.mainContext.undoManager = UndoManager()
            return modelContainer
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            CoffeeRecipeList()
        }
        .modelContainer(sharedModelContainer)
    }
}
