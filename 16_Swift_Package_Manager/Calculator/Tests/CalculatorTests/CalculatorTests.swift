import Testing
import XCTest
@testable import Calculator

@Test func example() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.

    let calculator = MyCalculator()

    #expect(27 == calculator.calculate())
}

final class CalculatorTests: XCTestCase {
    func testExample() throws {

        let calculator = MyCalculator()

        XCTAssertEqual(27, calculator.calculate());
    }
}
