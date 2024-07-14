//
//  XCTestExtensions.swift
//  PresenterUITests
//
//  Created by Paul Solt on 6/7/24.
//

import XCTest

extension XCUIElement {
    
    // Based on https://ashraf-ali-aa.github.io/XCUITest-Guide/docs/xcuitest/testing_if_elements_exist/
    
    @discardableResult
    func waitToDisappear(timeout: TimeInterval) -> Bool {
        let predicate = NSPredicate(format: "exists == false && isHittable == false")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: self)
        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        return result == .completed
    }
    
    func tapNearby(_ offset: CGVector) {
        // normalized at zero appears to be top left corner
        let normalized = coordinate(withNormalizedOffset: .zero)
        print("normalized: \(normalized)")
        let coordinate = normalized.withOffset(offset)
        print("coordinate: \(coordinate)")
        coordinate.tap()
    }
}

extension XCTestCase {
    // Based on: https://stackoverflow.com/a/42222302/276626
    func wait(for duration: TimeInterval) {
        let waitExpectation = expectation(description: "Waiting")
        
        let when = DispatchTime.now() + duration
        DispatchQueue.main.asyncAfter(deadline: when) {
            waitExpectation.fulfill()
        }
        waitForExpectations(timeout: duration)
    }
}


extension XCUIApplication {
    func tapCoordinate(at point: CGPoint) {
        let normalized = coordinate(withNormalizedOffset: .zero)
        let offset = CGVector(dx: point.x, dy: point.y)
        let coordinate = normalized.withOffset(offset)
        coordinate.tap()
    }
}
