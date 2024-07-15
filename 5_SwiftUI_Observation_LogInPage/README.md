# 2024-07-15 SwiftUI Login Page with Email Validation and Observation

"How do you make a SwiftUI app? In this video, I'll show you how to create a simple login screen with a model object using the new Observation framework, all in Xcode 16. Stay tuned to master this powerful tool and improve your app development!"

How do you create a Login Page or Login Screen? How should you structure your model objects? What is the new Observation framework? 

iOS 17 introduced the new Observation framework which moves away from Combine for ObservableObject and @Published properties to a new way of listening for changes that is more granular.

Learn how to create an @Observable model object and connect it to your SwiftUI interface in Xcode 16.

## Prototype UserValidator Class

```swift
import Observation

// NOTE: Observation does not support Combine! (no publishers on properties)

@Observable class UserValidator {
    var name = ""
    var email = ""
    var password = ""
    
    var isSubmitButtonDisabled: Bool {
        name.isEmpty || !isValidEmail(string: email) || password.count < 8
    }
    
    func isValidEmail(string: String) -> Bool {
        // https://www.hackingwithswift.com/swift/5.7/regexes
        // https://www.regular-expressions.info/email.html
        let emailRegex = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/
            .ignoresCase()
        return !string.ranges(of: emailRegex).isEmpty
    }
}
```

## Xcode 16 Feature: Cut and Paste to Create New File

Build simple UI using model object (bindings)

```swift
struct LogInView: View {
    @Bindable var userValidator: UserValidator
    
    var body: some View {
        VStack(spacing: 16) {
            TextField(text: $userValidator.name) {
                Text("Name")
            }
            .autocorrectionDisabled()
            .textInputAutocapitalization(.words)
            
            TextField(text: $userValidator.email) {
                Text("Email")
            }
            .autocorrectionDisabled()
            .keyboardType(.emailAddress)
            
            SecureField(text: $userValidator.password) {
                Text("Password")
            }
            
            Button("Create Account") {
                print("ViewMode: userName: \(userValidator.name), email:  \(userValidator.email), password: \(userValidator.password)")
            }
            .disabled(userValidator.isSubmitButtonDisabled)
        }
    }
}

#Preview {
    @Previewable @State var userValidator = UserValidator()
    
    LogInView(userValidator: userValidator)
}

```

## Customize the Keyboards

```swift
TextField(text: $userValidator.name) {
    Text("Name")
}
.autocorrectionDisabled()
.textInputAutocapitalization(.words)
```

```swift
TextField(text: $userValidator.email) {
    Text("Email")
}
.autocorrectionDisabled()
.keyboardType(.emailAddress)
```

## Group Styling

```swift
Group {
	TextField(...) 
	TextField(...)
	SecureField(...)
}
.padding()
.background(.background)
.clipShape(.rect(cornerRadius: 4))
```

## Add Dialog Styling

```swift
VStack(spacing: 16) {
    Text("Create Account")
        .padding(.bottom, 16)
    
    VStack(spacing: 16) {
        Group { ... }
        
        Button("Create Account") {
            print("ViewMode: userName: \(userValidator.name), email:  \(userValidator.email), password: \(userValidator.password)")
        }
        .padding(.top, 16)
        .keyboardShortcut(.defaultAction)
        .buttonStyle(.borderedProminent)
        .disabled(userValidator.isSubmitButtonDisabled)
    }
    .padding(40)
    .background(Color(UIColor.secondarySystemBackground))
    .cornerRadius(4)
    .padding(20)
}
```


## Resources

* <https://www.hackingwithswift.com/swift/5.7/regexes>
* <https://www.regular-expressions.info/email.html>
* <https://developer.apple.com/documentation/regexbuilder>