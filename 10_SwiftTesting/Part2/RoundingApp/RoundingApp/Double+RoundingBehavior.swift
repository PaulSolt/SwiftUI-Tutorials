//
//  RoundingBehavior.swift
//  RoundingApp
//
//  Created by Paul Solt on 11/6/24.
//


import Foundation

/// Used for controlling the output and rounding of the external "value"
extension Double {
        
    public enum RoundingBehavior {
        case none
        case tenths
        case hundredths
        case thousandths
    }

    /// Returns the internal value rounded based on rounding behavior
    public func rounded(to places: RoundingBehavior) -> Double {
        switch places {
        case .none:
            return self
        case .tenths:
            return self.roundedToPlaces(1)
        case .hundredths:
            return self.roundedToPlaces(2)
        case .thousandths:
            return self.roundedToPlaces(3)
        }
    }
    
    public func roundedToPlaces(_ places: Int) -> Double {
        let powerOfTen = pow(10.0, Double(places))
        return (self * powerOfTen).rounded() / powerOfTen
    }
}
