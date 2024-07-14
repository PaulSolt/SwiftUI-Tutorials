# How to Make a Full Screen Notification on macOS with NSPanel
2024-06-06

Learn how you can create a Full Screen Notification on macOS using a NSPanel that floats above all other Full Screen apps and windows. You can use this technique to take over the entire screen or to just show a little toast animation in a corner.

I use both AppKit (Cocoa) and SwiftUI to demo the notification message over the entire screen contents. Feel free to make adjustments to fit your needs.

![Full Screen Notification using NSPanel](hero-full-screen.png)


Learn how to write UI Tests on macOS with two UI Tests with supporting helper methods.

When testing apps you want to make your app accessible using `accessibilityIdentifiers`. You add identifiers so that the UX button text changes do not break your tests in the future.

## Add a UI Test Target

1. Add your UI Test Target
2. Remove boiler plate code for Launch Tests and UI Tests

## Create Your First UI Test

```swift
import XCTest

final class TestNotification_UITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
}
```

## Record Actions with a Breakpoint

```swift
func testNotificationDismissal() throws {
    // TODO: Breakpoint to record actions
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

## Test that Clicking Nearby Does not Dismiss

```swift
func testClickThroughTransparentRegion() throws {
    app.buttons["showNotification"].click()
    let notificationLabel = app.staticTexts["messageLabel"]
           
    XCTAssert(notificationLabel.exists)

    // TODO: Tap above notification label and verify we do not dismiss
}
```

## Implement XCUIElement Extensoin

```swift
func tapNearby(_ offset: CGVector) {
    // normalized at zero appears to be top left corner
    let normalized = coordinate(withNormalizedOffset: .zero)
    let coordinate = normalized.withOffset(offset)
    coordinate.tap()
}
```

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

Resources:
* https://ashraf-ali-aa.github.io/XCUITest-Guide/docs/xcuitest/testing_if_elements_exist/
* https://stackoverflow.com/a/42222302/276626
