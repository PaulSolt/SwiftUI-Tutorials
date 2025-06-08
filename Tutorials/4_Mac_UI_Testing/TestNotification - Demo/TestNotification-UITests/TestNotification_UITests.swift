//
//  TestNotification_UITests.swift
//  TestNotification-UITests
//
//  Created by Paul Solt on 6/7/24.
//

import XCTest

final class TestNotification_UITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testNotificationDismissesOnTap() throws {
        let button = app.buttons["showNotification"]
        let notificationLabel = app.staticTexts["messageLabel"]
        
        button.click()
        notificationLabel.click()
        
        XCTAssertTrue(notificationLabel.waitToDisappear(timeout: 3))
        //        XCTAssertTrue(notificationLabel.waitForNonExistence(withTimeout: 3)) // Xcode 16 Beta
    }
    
    func testClickThroughTransparentRegion() throws {
        showNotificationButton.click()
        XCTAssert(notificationLabel.exists)

        // Tap above notification label to verify we do not dismiss
        notificationLabel.tapNearby(CGVector(dx: 0, dy: -100))
        
        XCTAssert(notificationLabel.exists)
    }
    
    var showNotificationButton: XCUIElement {
        app.buttons["showNotification"]
    }
    
    var notificationLabel: XCUIElement {
        app.staticTexts["messageLabel"]
    }

//    func testClickThroughTransparentRegion() throws {
//        app.buttons["showNotification"].click()
//        let notificationLabel = app.staticTexts["messageLabel"]
//        XCTAssert(notificationLabel.exists)
//
//        // Tap above notification label to verify we do not dismiss
//        notificationLabel.tapNearby(CGVector(dx: 0, dy: -100))
//        
//        XCTAssert(notificationLabel.exists)
//    }
}
