## 2024-07-16 How to Refactor SwiftUI Views into Resuable Views

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
