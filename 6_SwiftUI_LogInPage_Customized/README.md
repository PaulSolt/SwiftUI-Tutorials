# 2024-07-16 SwiftUI Login Page Polish - TextField Customization


## Enable Focus on SwiftUI TextField and SecureField

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


## Make Input Easier for the User using Content Types

This allows for completions above the keyboard.

```swift
TextField(text: $userValidator.name) {
	// ... 
.textContentType(.name)

```

```swift
TextField(text: $userValidator.email) {
  // ...
.textContentType(.emailAddress)
```

`.newPassword` will help when creating new passwords, but also requires additional serverside plumbing with [associated domains](https://developer.apple.com/documentation/xcode/supporting-associated-domains) to allow for password expansion.

```swift
SecureField(text: $userValidator.password) {
	// ... 
.textContentType(.newPassword)
```

## Customize the Return Button on the iOS Keyboard

Customizing the text for the "return" button allows you to help the user navigate the next actions they can take in a form like dialog.

```swift
TextField(text: $userValidator.name) {
	// ... 
.submitLabel(.next)
```

```swift
TextField(text: $userValidator.email) {
  // ...
.submitLabel(.next)
```

Use something different for the last one.

```swift
SecureField(text: $userValidator.password) {
	// ... 
.submitLabel(.go)
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



------


## How to Refactor SwiftUI Views into Properties and Resuable Views

Extract to computed properties (`some View`)

```swift
    var nameTextField: some View {
        TextField(text: $userValidator.name) {
            Text("Name")
        }
        .padding()
        .background(.background) // Dark mode support
        .clipShape(.rect(cornerRadius: 4))
        .autocorrectionDisabled()
        .textInputAutocapitalization(.words)
        .focused($focusedField, equals: .nameField)
        .onTapGesture {
            focusedField = .nameField
        }
        .onSubmit {
            focusedField = .emailField
        }
        .submitLabel(.next)
        .textContentType(.name)
    }

    var emailTextField: some View {
        TextField(text: $userValidator.email) {
            Text("Email")
        }
        .padding()
        .background(.background) // Dark mode support
        .clipShape(.rect(cornerRadius: 4))
        
        .autocorrectionDisabled()
        .keyboardType(.emailAddress)
        .focused($focusedField, equals: .emailField)
        .onTapGesture {
            focusedField = .emailField
        }
        .submitLabel(.next)
        .onSubmit {
            focusedField = .passwordField
        }
        .textContentType(.emailAddress)
    }

    var passwordSecureField: some View {
        SecureField(text: $userValidator.password) {
            Text("Password")
        }
        .focused($focusedField, equals: .passwordField)
        .padding()
        .background(.background) // Dark mode support
        .clipShape(.rect(cornerRadius: 4))
        .onTapGesture {
            focusedField = .passwordField
        }
        .onSubmit {
            createAccount()
        }
        .textContentType(.newPassword)
    }
```

Update the UI

```swift
var body: some View {
    VStack(spacing: 16) {
        Text("Create Account")
            .bold()
            .padding(.bottom, 16)
        
        VStack(spacing: 16) {
            nameTextField
            
            emailTextField
            
            passwordSecureField
        }
        Button {
            createAccount()
        } label: {
            Text("Create Account")
                .bold()
        }
        .disabled(userValidator.isSubmitButtonDisabled)
        .padding(.top, 16)
        .buttonStyle(.borderedProminent)
        .keyboardShortcut(.defaultAction)
        
    }
    .padding(40)
    .background(Color(UIColor.secondarySystemBackground))
    .cornerRadius(4)
    .padding(20)
}
```

## CustomTextField to Reuse Logic (Separate Video)


```swift
import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    var placeholder: String
    var focus: LogInFocus // Focus of this UI element (Fixes tap area with additional padding)
    @FocusState var focusedField: LogInFocus?
    
    init(text: Binding<String>, placeholder: String, focus: LogInFocus, focusedField: LogInFocus? = nil) {
        self._text = text
        self.placeholder = placeholder
        self.focus = focus
        self.focusedField = focusedField
    }
    
    var body: some View {
        TextField(text: $text) {
            Text(placeholder)
        }
        .padding()
        .background(.background) // Dark mode support
        .clipShape(.rect(cornerRadius: 4))
        .autocorrectionDisabled()
        .onTapGesture {
            focusedField = focus    // Design Workaround: Tap the padding to activate the label
        }
        .submitLabel(.next)
        // .focused($focusedField, equals: focus) // Doesn't appear to work
    }
}

```

Rewrite the methods

```swift
// MARK: Views

var nameTextField: some View {
    CustomTextField(text: $userValidator.name, placeholder: "Name", focus: .nameField, focusedField: focusedField)
        .focused($focusedField, equals: .nameField)
        .textInputAutocapitalization(.words)
        .textContentType(.name)
}

var emailTextField: some View {
    CustomTextField(text: $userValidator.email, placeholder: "Email", focus: .emailField, focusedField: focusedField)
        .focused($focusedField, equals: .emailField)
        .keyboardType(.emailAddress)
        .textContentType(.emailAddress)
}

var passwordSecureField: some View {
    SecureField(text: $userValidator.password) {
        Text("Password")
    }
    .focused($focusedField, equals: .passwordField)
    .padding()
    .background(.background) // Dark mode support
    .clipShape(.rect(cornerRadius: 4))
    .onTapGesture {
        focusedField = .passwordField
    }
    .onSubmit {
        createAccount()
    }
    .textContentType(.newPassword)
}
```

Final thoughts: try the same thing for your SecureField to preserve the same styling.
