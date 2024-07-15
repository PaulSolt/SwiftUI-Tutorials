//
//  LogInView.swift
//  LogInObservation-End
//
//  Created by Paul Solt on 7/15/24.
//

import SwiftUI

import Observation // iOS 17

@Observable class UserValidator {
    var name = ""
    var email = ""
    var password = ""
    
    var isSubmitButtonDisabled: Bool {
        name.isEmpty || password.count < 8 || !isValidEmail(string: email)
    }
    
    func isValidEmail(string: String) -> Bool {
        // https://www.hackingwithswift.com/swift/5.7/regexes
        // https://www.regular-expressions.info/email.html
        let emailRegex = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/
            .ignoresCase()
        return !string.ranges(of: emailRegex).isEmpty
    }
}


struct LogInView: View {
    @Bindable var userValidator: UserValidator
    
    var body: some View {
        VStack {
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
            
            Button {
                print("Name: \(userValidator.name), Email: \(userValidator.email), Password: \(userValidator.password)")
            } label: {
                Text("Create Account")
            }
            .disabled(userValidator.isSubmitButtonDisabled)

        }
        .padding()
    }
}

#Preview {
    @Previewable @State var userValidator = UserValidator()
    
    LogInView(userValidator: userValidator)
}
