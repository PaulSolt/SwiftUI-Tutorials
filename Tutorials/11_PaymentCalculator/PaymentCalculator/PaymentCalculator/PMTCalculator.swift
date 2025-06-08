//
//  PMTCalculator.swift
//  PaymentCalculator
//
//  Created by Paul Solt on 11/15/24.
//

import Foundation

struct PMTCalculator {
    /*
    PMT function is P = (Pv*R) / (1 - (1 + R)^(-n))

    P = Monthly Payment
    Pv = Present Value (starting value of the loan)
    APR = Annual Percentage Rate
    R = Periodic Interest Rate = APR/number of interest periods per year
    n = Total number of interest periods (interest periods per year * number of years)
     */

    static func calculate(loanAmount: Double, apr: Double, months: Double) -> Double {
        let R = apr / 12
        let result = loanAmount * R / (1 - pow(1 + R, -months))
        return result
    }
}
