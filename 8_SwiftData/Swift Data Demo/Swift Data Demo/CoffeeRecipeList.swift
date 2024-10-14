//
//  CoffeeRecipeList.swift
//  Swift Data Demo
//
//  Created by Paul Solt on 7/24/24.
//

import SwiftUI
import SwiftData
struct CoffeeRecipeDetail: View {
    @Environment(\.modelContext) private var modelContext

    var recipe: CoffeeRecipe
    
    @State var coffeeWeight: String = ""
    
    init(recipe: CoffeeRecipe) {
        self.recipe = recipe
        
//        let weightString = massFormatter.string(fromValue: recipe.coffeeWeight, unit: .gram)
        _coffeeWeight = State(initialValue: "\(recipe.coffeeWeight)")
    }
    
    var massFormatter: MassFormatter = {
        let massFormatter = MassFormatter()
        massFormatter.unitStyle = .medium
        massFormatter.isForPersonMassUse = false
        return massFormatter
    }()
    
    func coffeeWeightString(recipe: CoffeeRecipe) -> String {
        massFormatter.string(fromValue: recipe.coffeeWeight, unit: .gram)
    }

    var body: some View {
        VStack {
            Text("Coffee weight")
            TextField("Coffee Weight", text: $coffeeWeight)
//            TextField("Coffee Weight", value: $coffeeWeight) //, formatter: massFormatter)
            Button("Save") {
                recipe.coffeeWeight = Double(coffeeWeight) ?? 1
//                modelContext.insert(recipe)
                try? modelContext.save()
            }
        }
        .onAppear {
//            coffeeWeight = recipe.coffeeWeight
            print("hello!")
        }
    }
}

struct CoffeeRecipeList: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \CoffeeRecipe.dateModified) private var recipes: [CoffeeRecipe]
    
    var massFormatter: MassFormatter = {
        let massFormatter = MassFormatter()
        massFormatter.unitStyle = .medium
        massFormatter.isForPersonMassUse = false
        return massFormatter
    }()
   
    func coffeeWeightString(recipe: CoffeeRecipe) -> String {
        massFormatter.string(fromValue: recipe.coffeeWeight, unit: .gram)
    }
    
    @State private var multipleSelection = Set<UUID>()

    var body: some View {
        NavigationSplitView {
            List { //selection: $multipleSelection) {
                ForEach(recipes) { recipe in
                    let coffeeWeight = coffeeWeightString(recipe: recipe)

                    NavigationLink {
                        VStack {
                            Text("\(recipe.title) Coffee: \(coffeeWeight)")
                            Text("Modified: \(recipe.dateModified, format: Date.FormatStyle(date: .numeric, time: .standard))")
                            CoffeeRecipeDetail(recipe: recipe)
                        }

                    } label: {
                        Text("\(recipe.title), \(coffeeWeight)")

                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Recipe", systemImage: "plus")
                    }
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    Button(action: {
                        if modelContext.undoManager?.canUndo == true {
                            modelContext.undoManager?.undo()
                        }
                        
                    }) {
                        Label("Undo", systemImage: "arrow.uturn.backward")
                    }
                    .disabled(modelContext.undoManager?.canUndo == false)
                    
                    Button(action: {
                        if modelContext.undoManager?.canRedo == true {
                            modelContext.undoManager?.redo()
                        }
                        
                    }) {
                        Label("Redo", systemImage: "arrow.uturn.forward")
                    }
                    .disabled(modelContext.undoManager?.canRedo == false)

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
            try? modelContext.save()
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
            try? modelContext.save()
        }
    }
}

#Preview {
    CoffeeRecipeList() //undoManager: UndoManager())
        .modelContainer(for: CoffeeRecipe.self, inMemory: true)
}
