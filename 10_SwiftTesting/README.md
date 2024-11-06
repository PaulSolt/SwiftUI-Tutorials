# Swift Testing in Xcode 16
2024-11-06

## Part 1: Swift Testing with Floating Point Values (Double and Float Calculations)

If you used the accuracy XCTest method, you're out of luck in Swift Testing: 

```swift
XCTAssertEqual(305.395, a.roundedToPlaces(3), accuracy: 0.000001)
```

There is no Swift Testing helper for testing floating point calculations. The current best practice is to use Swift Numerics, since cross-platform floating point math is 

1. File > Add Package: <https://github.com/apple/swift-numerics>
2. Add `Numerics` Library to unit test target
3. Add the framework in the code file: `import Numerics`
4. Write unit test:

```swift
import Numerics
import Testing
@testable import RoundingApp

struct RoundingAppTests {

    @Test func example() async throws {
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
```

## Part 2: Swift Testing Explored

* [Swift Testing Vision](https://github.com/swiftlang/swift-evolution/blob/main/visions/swift-testing.md)

```swift
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

```