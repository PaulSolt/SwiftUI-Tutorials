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

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        
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

}
