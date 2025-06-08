//
//  LogInView.swift
//  LogInObservation-End
//
//  Created by Paul Solt on 7/15/24.
//

import SwiftUI


struct LogInView: View {
    @Bindable var userValidator: UserValidator
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Create Account")
                .bold()
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
                    .onSubmit {
                        print("Name: \(userValidator.name), Email: \(userValidator.email), Password: \(userValidator.password)")
                    }
                }
                //            .textFieldStyle(.roundedBorder)
                .padding()
                .background(.background) // Dark mode support
                .clipShape(.rect(cornerRadius: 4))
            }
            Button {
                print("Name: \(userValidator.name), Email: \(userValidator.email), Password: \(userValidator.password)")
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
}

//@available(iOS 18, *)
//#Preview {
//    @Previewable @State var userValidator = UserValidator()
//    
//    LogInView(userValidator: userValidator)
//}

#Preview {
    LogInView(userValidator: UserValidator())
}
