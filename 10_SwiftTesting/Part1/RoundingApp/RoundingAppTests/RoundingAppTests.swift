//
//  RoundingAppTests.swift
//  RoundingAppTests
//
//  Created by Paul Solt on 11/6/24.
//

import Numerics
import Testing
@testable import RoundingApp

struct RoundingAppTests {

    @Test func roundingBehaviorsWithAccuracy() async throws {
        let a = 305.39483
        let b = 905.0
        let c = 123.22222
        
        #expect(a.roundedToPlaces(3) == 305.395)
        #expect(b.roundedToPlaces(3) == 905.0)
        #expect(c.roundedToPlaces(3) == 123.222)
        
        let result = 127.0 / 53 // 2.3962264151
//        #expect(result == 2.396226)
        #expect(result.isApproximatelyEqual(to: 2.396, absoluteTolerance: 0.001))
    }
    
    @Test func playingWithTests() async throws {
        
        let x = 20
        let y = 3
        let result = y * 25
        #expect(x < result)
        #expect(x < result)
    }

    @Test func requireTests() async throws {
        let x: Int? = 10
    //        let y: String? = nil
        let xUnwrapped = try #require(x)

        let z = xUnwrapped * 100
        #expect(z == 1_000)
        
        try #require(2 == 2)
    //        try #require(2 == 7)
        
    //        x = nil
    //        #expect(x != nil)
        
    }

    @Test func arrayTesting() async throws {
        
        let a = [1, 2, 3, 7] //[3, 1, 2, 7]
        let b = 7
        
        #expect(a.contains(b))
        
        let aPrime = [1, 2, 3, 7]
        #expect(a == aPrime)
    }
}
