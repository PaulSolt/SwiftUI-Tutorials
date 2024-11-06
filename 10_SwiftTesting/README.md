# Swift Testing in Xcode 16
2024-11-06

There is no direct helper for testing floating point calculations. The current best practice is to use Swift Numerics, since cross-platform floating point math is 

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
