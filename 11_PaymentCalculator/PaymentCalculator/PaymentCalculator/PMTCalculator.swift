//
//  PMTCalculator.swift
//  PaymentCalculator
//
//  Created by Paul Solt on 11/14/24.
//

import Foundation

struct PMTCalculator {
    static func calculate(loanAmount: Double, apr: Double, months: Double) -> Double {
        
        /*
         PMT function is P = (Pv*R) / (1 - (1 + R)^(-n))
         
         P = Monthly Payment
         Pv = Present Value (starting value of the loan)
         APR = Annual Percentage Rate
         R = Periodic Interest Rate = APR/number of interest periods per year
         n = Total number of interest periods (interest periods per year * number of years)
         */
        let r = apr / 12.0 // monthly
        
        let result = loanAmount * r / (1 - pow(1 + r, -months))
        return result
    }
}
