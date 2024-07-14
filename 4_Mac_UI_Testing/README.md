# Introduction to UI Testing on macOS with XCTest
2024-06-06

Let's UI Test the Full Screen Notification macOS app.

When testing apps you want to make your app accessible using `accessibilityIdentifiers`. You add identifiers so that the UX button text changes do not break your tests in the future.

Learn how to write UI Tests on macOS with two UI Tests with supporting helper methods.

When testing apps you want to make your app accessible using `accessibilityIdentifiers`. You add identifiers so that the UX button text changes do not break your tests in the future.

## Add a UI Test Target

1. Add your UI Test Target
2. Remove boiler plate code for Launch Tests and UI Tests

## Create Your First UI Test

```swift
import XCTest

final class TestNotification_UITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
}
```

## Record Actions inside Test Methods


```swift
func testNotificationDismissal() throws {
	// Option 1: Select cursor inside body of a test method and press record
	// Option 2: Alternate: Use breakpoint and then start recording
}
```

Note: `@MainActor` may prevent you from being able to record during a breakpoint

NOTE: It is hard to follow and it would be less brittle with identifiers that didn't change with text.

```swift
func testNotificationDismissal() {
	let app = XCUIApplication()
	app.windows["TestNotification.ContentView-1-AppWindow-1"].buttons["Show Full Screen Notification"].click()
	app.staticTexts["This is a full screen notification"].click()
}
```

## Making UI Testable

To make UI tests not brittle, we need to use `accessibilityIdentifiers` so that UI elements always have the same name (regardless of localization, UI updates, etc.).

## Update ContentView Accessibilty

```swift
Button("Show Full Screen Notification") {
    FullScreenNotification.showNotification()
}
.accessibilityIdentifier("showNotification")
```

## Update the NSTextField Accessibility

```swift
messageLabel.setAccessibilityIdentifier("messageLabel")
```


## Clean Up with Variables and identifiers

```swift
func testNotificationDismissesOnTap() throws {
    let button = app.buttons["showNotification"]
    let notificationLabel = app.staticTexts["messageLabel"]
    
    button.click()
    notificationLabel.click()

	// TODO: Verify it worked
    XCTAssert(notificationLabel.waitToDisappear(timeout: 3))
}
```

# Xcode 16+

> A new API on XCUIElement adds the ability to wait for any property on XCUIElement to become a value given a timeout. Also, `waitForNonExistence` has been added as a new API. (35419925)

```swift
wait(for:toEqual:timeout:)
waitForNonExistence(withTimeout:)
```


## Tap a Button - Add Identifiers

Use the identifiers:

```swift
func testNotificationDismissal() throws {
    app.buttons["showNotification"].click()
    let notificationLabel = app.staticTexts["messageLabel"]
    
    notificationLabel.click()

	// TODO: Verify the notication disappears
}
```


## Testing UI Disappears

We need an extension to customize XCTest so that we can know when something disappears.

You can build your own library of helper methods.

## XCUIElement Extension

```swift
import XCTest

extension XCUIElement {
    @discardableResult
    func waitToDisappear(timeout: TimeInterval) -> Bool {
    
    }
}
```

## Implement `waitToDisappear` in `XCUIElement`:

```swift
func waitToDisappear(timeout: TimeInterval) -> Bool {
    let predicate = NSPredicate(format: "exists == false && isHittable == false")
    let expectation = XCTNSPredicateExpectation(predicate: predicate, object: self)
    let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
    return result == .completed
}
```

## Finish the First Test

```swift
func testNotificationDismissesOnTap() throws {
    let button = app.buttons["showNotification"]
    let notificationLabel = app.staticTexts["messageLabel"]
    
    button.click()
    notificationLabel.click()
    
    XCTAssertTrue(notificationLabel.waitToDisappear(timeout: 3))
    //        XCTAssertTrue(notificationLabel.waitForNonExistence(withTimeout: 3)) // Xcode 16 Beta
}
```


## 2nd Test: Test that Clicking Nearby Does not Dismiss

```swift
func testClickThroughTransparentRegion() throws {
    app.buttons["showNotification"].click()
    let notificationLabel = app.staticTexts["messageLabel"]
           
    XCTAssert(notificationLabel.exists)

    // TODO: Tap above notification label and verify we do not dismiss
}
```

## Implement XCUIElement Extension

```swift
func tapNearby(_ offset: CGVector) {
    // normalized at zero appears to be top left corner
    let normalized = coordinate(withNormalizedOffset: .zero)
    let coordinate = normalized.withOffset(offset)
    coordinate.tap()
}
```

## Add Test Condition

```swift
func testClickThroughTransparentRegion() throws {
    app.buttons["showNotification"].click()
    let notificationLabel = app.staticTexts["messageLabel"]
    XCTAssert(notificationLabel.exists)

    // Tap above notification label to verify we do not dismiss
    notificationLabel.tapNearby(CGVector(dx: 0, dy: -100))

    XCTAssert(notificationLabel.exists)
}
```

## Cleanup with Reusable Elements

```swift
var showNotificationButton: XCUIElement {
    app.buttons["showNotification"]
}

var notificationLabel: XCUIElement {
    app.staticTexts["messageLabel"]
}
```

Updated Method:

```swift
func testClickThroughTransparentRegion() throws {
    showNotificationButton.click()
    XCTAssert(notificationLabel.exists)

    // Tap above notification label to verify we do not dismiss
    notificationLabel.tapNearby(CGVector(dx: 0, dy: -100))
    
    XCTAssert(notificationLabel.exists)
}
```

Resources:
* https://ashraf-ali-aa.github.io/XCUITest-Guide/docs/xcuitest/testing_if_elements_exist/
* https://stackoverflow.com/a/42222302/276626
