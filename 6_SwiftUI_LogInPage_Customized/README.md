# 2024-07-16 SwiftUI Login Page Polish - TextField Customization

## Problem: Padding is not tappable around TextField and SecureField

Use: FocusState to set the focused UI element when tapping near a TextField.

```swift
enum LogInFocus: Int, Hashable {
  case nameField, emailField, passwordField
}
```

```swift
TextField(text: $userValidator.name) {
  // ...
.focused($focusedField, equals: .name)
.onTapGesture {
    focusedField = .nameField
}
```

```swift
TextField(text: $userValidator.email) {
  // ...
.focused($focusedField, equals: .email)
.onTapGesture {
    focusedField = .email
}
```

```swift
SecureField(text: $userValidator.password) {
	// ... 
.focused($focusedField, equals: .password)
.onTapGesture {
    focusedField = .password
}

```


## Update the Keyboard Return Button

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

```swift
SecureField(text: $userValidator.password) {
	// ... 
.textContentType(.newPassword)

```

## Next Text Field using FocusState

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

Add a new Method to UserValidator:

```swift
func createAccount() {
    print("Name: \(name), Email: \(email), Password: \(password)")
}
```

## Properties for Variables to Cleanup

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
