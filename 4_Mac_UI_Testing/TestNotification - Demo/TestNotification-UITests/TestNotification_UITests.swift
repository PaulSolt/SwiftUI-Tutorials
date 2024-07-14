//
//  TestNotification_UITests.swift
//  TestNotification-UITests
//
//  Created by Paul Solt on 6/7/24.
//

import XCTest

final class TestNotification_UITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func testNotificationDismissesOnTap() throws {
        app.buttons["showNotification"].click()
        let notificationLabel = app.staticTexts["messageLabel"]
        
        notificationLabel.click()
        
        XCTAssert(notificationLabel.waitToDisappear(timeout: 3))
    }
    
    func testClickThroughTransparentRegion() throws {
        app.buttons["showNotification"].click()
        let notificationLabel = app.staticTexts["messageLabel"]
        XCTAssert(notificationLabel.exists)

        // Tap above notification label to verify we do not dismiss
        notificationLabel.tapNearby(CGVector(dx: 0, dy: -100))
        XCTAssert(notificationLabel.exists)
    }
}
