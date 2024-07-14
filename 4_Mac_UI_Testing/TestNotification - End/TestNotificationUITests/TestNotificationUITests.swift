//
//  TestNotificationUITests.swift
//  TestNotificationUITests
//
//  Created by Paul Solt on 7/14/24.
//

import XCTest

final class TestNotificationUITests: XCTestCase {
    var app: XCUIApplication!
    
    var showNotificationButton: XCUIElement {
        app.buttons["showNotification"]
    }
    
    var notificationMessageLabel: XCUIElement {
        app.staticTexts["messageLabel"]
    }
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testTapOnNotificationDismissesIt() {
        // Option 1: Record UI test
        // Option 2: Set a breakpoint and record after that breakpoint
        
        // Save file and then try to record a UI test
        
        showNotificationButton.click()
        notificationMessageLabel.click()
        
        // Verify the notification goes away
        
        // Xcode 15 and lower
        notificationMessageLabel.waitToDisappear(timeout: 3)
        
        // Xcode 16 and later
//        notificationMessageLabel.waitForNonExistence(withTimeout: 3)
    }
    
    func testClickThroughTransparentRegionDoesNotDismissNotification() {
        showNotificationButton.click()
        XCTAssert(notificationMessageLabel.exists)
        
        // Tap outside the notification and verify it does not dismiss
        notificationMessageLabel.tapNearby(CGVector(dx: 0, dy: -100))
       
        wait(for: 1) // wait 1 second
        XCTAssert(notificationMessageLabel.exists)
    }
    
}
