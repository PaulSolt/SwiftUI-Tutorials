//
//  LogInView.swift
//  LogInCombine
//
//  Created by Paul Solt on 7/14/24.
//

import SwiftUI

struct LogInView: View {
    @Bindable var userValidator: UserValidator
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Create Account")
                .padding(.bottom, 16)
            
            VStack(spacing: 16) {
                Group {
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
                }
//                .textFieldStyle(.roundedBorder)
                .padding()
                .contentShape(Rectangle())
                .background(.background)
                .clipShape(.rect(cornerRadius: 4))
            }

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
}

#Preview {
    @Previewable @State var userValidator = UserValidator()
    
    LogInView(userValidator: userValidator)
}
