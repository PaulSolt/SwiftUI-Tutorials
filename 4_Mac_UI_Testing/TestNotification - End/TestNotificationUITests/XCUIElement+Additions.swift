//
//  XCUIElement+Additions.swift
//  TestNotification
//
//  Created by Paul Solt on 7/14/24.
//

import XCTest

extension XCUIElement {
    
    // wait to disappear (Xcode 15 and lower)
    @discardableResult
    func waitToDisappear(timeout: TimeInterval) -> Bool {
        let predicate = NSPredicate(format: "exists == false && isHittable == false")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: self)
        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        return result == .completed
    }
    
    // tap nearby an element
    func tapNearby(_ offset: CGVector) {
        // normalized at zero appears to be the top left corner
        let normalized = coordinate(withNormalizedOffset: .zero)
        let coordinate = normalized.withOffset(offset)
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
