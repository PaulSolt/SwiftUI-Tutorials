//
//  CoffeeRecipe.swift
//  Swift Data Demo
//
//  Created by Paul Solt on 7/24/24.
//

import Foundation
import SwiftData

enum BrewMethod: String, Codable {
    case chemex_3Cup
    case chemex_6Cup       // First supported type
    case chemex_10Cup

    case harioV60_Size1     // Second supported type
    case harioV60_Size2
    case harioV60_Size3
}

enum CoffeeType {
    case regular
    case decaf
    case decafBlend(decafToRegularRatio: Float)  // 0.0 to 1.0 of decaf to regular
}

struct CoffeeConstants {
    static let kHarioV60_1_WaterFilterWeight: Double = 4.7 - 0.8 // 4.7 grams wet, 0.8 grams dry
    static let kChemex_6Cup_WaterFilterWeight: Double = 18.5 - 5.2 // 18.5 grams wet, 5.2 grams dry
    static let kGramsInOunceOfWater: Double = 29.5735296875  // 29.57 grams in 1 fluid US ounce
}

class DefaultRecipes {
    static let chemex_6cup = CoffeeRecipe(
        dateModified: .now,
        title: "6-cup Chemex",
        brewMethod: .chemex_6Cup,
        waterToCoffeeRatio: 17.0,
        coffeeWeight: 56.0,
        bloomRatio: 2,
        bloomTime: 30,
        pourTime: 3 * 60,
        drainTime: 5 * 60,
        cupSize: 4
    )
    
    static let harioV60_size1 = CoffeeRecipe(
        dateModified: .now,
        title: "Hario V60 (Size 01)", // TODO: Show a 01 badge on the icon
        brewMethod: .harioV60_Size1,
        waterToCoffeeRatio: 16.2,
        coffeeWeight: 21,
        waterWeight: 340,
        bloomRatio: 2,
        bloomTime: 30,
        pourTime: 2 * 60,
        drainTime: 2.5 * 60,
        cupSize: 4
    )
}

@Model
final class CoffeeRecipe {
    var id: UUID = UUID()
    var dateModified: Date = Date.distantPast
    var title: String = "6-cup Chemex"
    var brewMethod: BrewMethod = BrewMethod.chemex_6Cup
    var waterToCoffeeRatio: Double = 17     // 17g water : 1g coffee
    var coffeeWeight: Double = 56           // 56 grams
    var waterWeight: Double = 952           // 952 grams
    var bloomRatio: Double = 2              // 2:1 coffee:water bloom weight
    
    var bloomTime: TimeInterval = 30        // 30 seconds
    var pourTime: TimeInterval = 3.5 * 60   // 3:30 minutes
    var drainTime: TimeInterval = 5 * 60    // 5 minutes
    
    // FIXME: Cupsize feels like it's an app setting
    var cupSize: Double = 4 /// Currently 4oz is the default since I use small cups (may change to mL)
    var servings: Double = 6 /// Calculated based on estimated yeild from brew method
    
    // Current Brew settings
    @Transient var duration: TimeInterval = 0
    @Transient var currentWaterWeight: Double = 0
    
    init(id: UUID? = nil, dateModified: Date, title: String, brewMethod: BrewMethod, waterToCoffeeRatio: Double, coffeeWeight: Double, waterWeight: Double? = nil, bloomRatio: Double, bloomTime: TimeInterval, pourTime: TimeInterval, drainTime: TimeInterval, cupSize: Double, servings: Double? = nil, duration: TimeInterval? = nil, currentWaterWeight: Double? = nil) {
        self.id = if let id { id } else { UUID() }
        self.dateModified = dateModified
        self.title = title
        self.brewMethod = brewMethod
        self.waterToCoffeeRatio = waterToCoffeeRatio
        self.coffeeWeight = coffeeWeight
        self.waterWeight = 1    // Set a default, we'll calculate below
        self.bloomRatio = bloomRatio
        self.bloomTime = bloomTime
        self.pourTime = pourTime
        self.drainTime = drainTime
        self.cupSize = cupSize
        self.servings = 1       // Set a default, we'll calculate below
        self.duration = if let duration { duration } else { 0 }
        self.currentWaterWeight = if let currentWaterWeight { currentWaterWeight } else { 0 }
        
        // Calculate and set properties after all instance values are set
        if let waterWeight {
            self.waterWeight = waterWeight
        } else {
            self.waterWeight = calculateWaterWeight(fromCoffeeWeight: coffeeWeight, waterToCoffeeRatio: waterToCoffeeRatio)
        }
        
        if let servings {
            self.servings = servings
        } else {
            self.servings = calculateServings(fromWaterWeight: self.waterWeight, coffeeWeight: coffeeWeight, brewMethod: brewMethod, cupSize: cupSize)
        }
    }
    
    /// Make a copy of the recipe with a new UUID
    func copy() -> CoffeeRecipe {
        return CoffeeRecipe(
            dateModified: .now,
            title: title,
            brewMethod: brewMethod,
            waterToCoffeeRatio: waterToCoffeeRatio,
            coffeeWeight: coffeeWeight,
            waterWeight: waterWeight,
            bloomRatio: bloomRatio,
            bloomTime: bloomTime,
            pourTime: pourTime,
            drainTime: drainTime,
            cupSize: cupSize,
            servings: servings,
            duration: duration,
            currentWaterWeight: currentWaterWeight
        )
    }
    
    /// Reset to the beginning of a brew
    /// We may not want to call on init, if we want to support resuming a recipe because the wrong mode was started
    func reset() {
        duration = 0
        currentWaterWeight = 0
    }
    
    func updateWaterToCoffeeRatio(_ waterCoffeeRatio: Double) {
        self.waterToCoffeeRatio = waterCoffeeRatio
        self.waterWeight = calculateWaterWeight(fromCoffeeWeight: self.coffeeWeight, waterToCoffeeRatio: self.waterToCoffeeRatio)
        updateServings()
    }
    
    /// Updates the water weight and recalculates the coffee weight and servings using recipe ratio
    func updateWaterWeight(_ waterWeight: Double) {
        self.waterWeight = waterWeight
        self.coffeeWeight = calculateCoffeeWeight(fromWaterWeight: waterWeight, waterToCoffeeRatio: self.waterToCoffeeRatio)
        updateServings()
    }
    
    /// Updates the coffee weight and recaculates the water weight and servings using recipe ratio
    func updateCoffeeWeight(_ coffeeWeight: Double) {
        self.coffeeWeight = coffeeWeight
        self.waterWeight = calculateWaterWeight(fromCoffeeWeight: self.coffeeWeight, waterToCoffeeRatio: self.waterToCoffeeRatio)
        updateServings()
    }
    
    /// Updates cup size and recalculates the servings
    func updateCupSize(_ cupSize: Double) {
        self.cupSize = cupSize
        updateServings()
    }
    
    /// Updates the servings calculation using the recipe settings (water, coffee, brew method, cup size)
    func updateServings() {
        servings = calculateServings(fromWaterWeight: self.waterWeight, coffeeWeight: self.coffeeWeight, brewMethod: self.brewMethod, cupSize: self.cupSize)
    }
    
    func calculateWaterWeight(fromCoffeeWeight weight: Double, waterToCoffeeRatio: Double) -> Double {
        return weight * waterToCoffeeRatio
    }

    func calculateCoffeeWeight(fromWaterWeight weight: Double, waterToCoffeeRatio: Double) -> Double {
        return weight / waterToCoffeeRatio
    }

    // Calculates servings in fluid Ounces -> Cups
    func calculateServings(fromWaterWeight waterWeight: Double, coffeeWeight: Double, brewMethod: BrewMethod, cupSize: Double) -> Double {
        
        var wetFilterWeight: Double = 0
        var wetCoffeeWeight: Double = 0
        switch(brewMethod) {
        case BrewMethod.chemex_6Cup:
            wetFilterWeight = CoffeeConstants.kChemex_6Cup_WaterFilterWeight
            wetCoffeeWeight = coffeeWeight * 4
        case BrewMethod.harioV60_Size1:
            wetFilterWeight = CoffeeConstants.kHarioV60_1_WaterFilterWeight
            wetCoffeeWeight = coffeeWeight * 3
        default:
            wetFilterWeight = 0  // default, don't adjust for weight
            wetCoffeeWeight = 0
        }
        
        let brewedCoffeeYieldWeight = waterWeight - (wetFilterWeight + wetCoffeeWeight)
        let fluidOuncesCoffee = brewedCoffeeYieldWeight / CoffeeConstants.kGramsInOunceOfWater
        
        return fluidOuncesCoffee / cupSize
    }

}
