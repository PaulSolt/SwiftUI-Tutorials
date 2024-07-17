# 2024-07-16 SwiftUI Login Page Polish - TextField Customization

How to Use TextField Keyboard Focus in SwiftUI with @FocusState


## Enable Focus on SwiftUI TextField and SecureField

"Are you struggling with managing keyboard focus in your SwiftUI login forms? In this video, I'm going to show you how to take control of TextField focus, customize your input fields, and enhance user experience effortlessly. Let's dive in!"

Use: FocusState to set the focused UI element when tapping near a TextField.

```swift
enum LogInFocus: Int, Hashable {
  case nameField, emailField, passwordField
}
```

Add: 

```swift
@FocusState var focusedField: LogInFocus?
```

Annotate each text field.

```swift
TextField(text: $userValidator.name) {
  // ...
.focused($focusedField, equals: .nameField)
```

```swift
TextField(text: $userValidator.email) {
  // ...
.focused($focusedField, equals: .emailField)
```

```swift
SecureField(text: $userValidator.password) {
	// ... 
.focused($focusedField, equals: .passwordField)
```

Now for the top level `VStack`, make it set the keyboard focus.

```swift
.onAppear {
    focusedField = .nameField
}
```

## Problem: Padding Around Custom TextField is Not Tappable

If you need to match UX, there isn't a good way to expand the tap region beyond using a tap gesture and focus.

To get this to work you'll need to add a `clipShape` or `contentShape` before the `tapGesture`.

We need to move padding inside with clip shape to fix tap issue. Remove the `Group` and duplicate this code across all inputs (Refactor it later).

```swift
.padding(50)
.background(.background) // Dark mode support
.clipShape(.rect(cornerRadius: 4))
```

Then you can append the tap gesture

```swift
TextField(text: $userValidator.name) {
  // ...
.clipShape(.rect(cornerRadius: 4))
.onTapGesture {
    focusedField = .nameField
}
```

```swift
TextField(text: $userValidator.email) {
  // ...
.clipShape(.rect(cornerRadius: 4))
.onTapGesture {
    focusedField = .email
}
```

```swift
SecureField(text: $userValidator.password) {
	// ... 
.clipShape(.rect(cornerRadius: 4))
.onTapGesture {
    focusedField = .password
}

```


## Make Input Easier for the User using Content Types and Submit Labels

1. When you set the `textContentType()` iOS will show completions above the keyboard.
2. You can customize the "return" button on the keyboard using the `submitLabel()`.

```swift
TextField(text: $userValidator.name) {
	// ... 
.textContentType(.name)
.submitLabel(.next)
```

```swift
TextField(text: $userValidator.email) {
  // ...
.textContentType(.emailAddress)
.submitLabel(.next)
```

`.newPassword` will help when creating new passwords, but also requires additional serverside plumbing with [associated domains](https://developer.apple.com/documentation/xcode/supporting-associated-domains) to allow for password expansion.

```swift
SecureField(text: $userValidator.password) {
	// ... 
.textContentType(.newPassword)
.submitLabel(.continue)
```

## Next Text Field using FocusState

Make it easy to move focus when the "return" button is pressed
```swift
TextField(text: $userValidator.name) {
	// ... 
.onSubmit {
    focusedField = .emailField
}

```

```swift
TextField(text: $userValidator.email) {
  // ...
.onSubmit {
    focusedField = .password
}
```

```swift
SecureField(text: $userValidator.password) {
	// ... 
.onSubmit {
    createAccount()
}

```

Add a method stub:

```swift
func createAccount() {
}
```

## Custom Logic for Create Account

Add a new Method to `UserValidator`:

```swift
func createAccount() {
    print("Name: \(name), Email: \(email), Password: \(password)")
}
```

In `LogInView` update the method stub for `createAccount()`

```swift
func createAccount() {
    // TODO: Warn user if input is empty (reader exercise)
    
    if !userValidator.isSubmitButtonDisabled {
        focusedField = nil
        userValidator.createAccount()
    } else {
        print("Error: Please enter valid name, email, and 8+ character password")
    }
}
```

## Spinning ProgressView on Button

Add a new property: to `UserValidator`

```swift
var creatingAccount = false
```

For now we will only set it, to show how easy it is to provide a progress indicator. You can add a timer or web call to reset the value or transition to the next screen.

```swift
func createAccount() {
    print("Create account: \(name), email: \(email), password: \(password)")
    creatingAccount = true 
    // TODO: do something to progress the user in the app
}
```

Then in `LogInView` update the button label:

```swift
Button {
    userValidator.createAccount()
} label: {
    Group {
        if userValidator.creatingAccount {
            ProgressView()
        } else {
            Text("Create Account")
                .bold()
        }
    }
    .frame(minWidth: 200)
}
```
