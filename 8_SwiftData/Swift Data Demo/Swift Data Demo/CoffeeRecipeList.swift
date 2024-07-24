//
//  CoffeeRecipeList.swift
//  Swift Data Demo
//
//  Created by Paul Solt on 7/24/24.
//

import SwiftUI
import SwiftData

struct CoffeeRecipeList: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \CoffeeRecipe.dateModified) private var recipes: [CoffeeRecipe]
    @Environment(\.undoManager) var undoManager

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(recipes) { recipe in
                    NavigationLink {
                        VStack {
//                            let weightString = MassFormatter().unitString(fromKilograms: recipe.coffeeWeight / 1000.0, usedUnit: UnitMass)
                            Text("\(recipe.title) Coffee: \(recipe.coffeeWeight)) Water: \(recipe.waterWeight)")
                            Text("Modified: \(recipe.dateModified, format: Date.FormatStyle(date: .numeric, time: .standard))")
                        }

                    } label: {
                        Text("\(recipe.title), \(recipe.coffeeWeight)g")

                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Recipe", systemImage: "plus")
                    }
                }
                ToolbarItem {
                    Button(action: {
                        undoManager?.undo()
                    }) {
                        Label("Undo", systemImage: "refresh")
                    }
                }
                
            }
        } detail: {
            Text("Select a Recipe")
        }
    }

    private func addItem() {
        withAnimation {
            let random = Int.random(in: 0...1)
            var recipe = DefaultRecipes.chemex_6cup.copy()
            if random == 1 { recipe = DefaultRecipes.harioV60_size1.copy() }
            
            recipe.dateModified = .now
            recipe.coffeeWeight = Double.random(in: 21 ... 56).rounded()
            modelContext.insert(recipe)
//            try? modelContext.save()
        }
    }

    func createDefaultRecipes() {
        DefaultRecipes.chemex_6cup
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(recipes[index])
            }
//            try? modelContext.save()
        }
    }
}

#Preview {
    CoffeeRecipeList()
        .modelContainer(for: CoffeeRecipe.self, inMemory: true)
}
