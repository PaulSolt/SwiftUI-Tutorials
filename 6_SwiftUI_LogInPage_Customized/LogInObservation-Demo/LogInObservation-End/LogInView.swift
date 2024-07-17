//
//  LogInView.swift
//  LogInObservation-End
//
//  Created by Paul Solt on 7/15/24.
//

import SwiftUI

enum LogInFocus: Int, Hashable {
  case nameField, emailField, passwordField
}

struct LogInView: View {
    @Bindable var userValidator: UserValidator
    @FocusState private var focusedField: LogInFocus?

    var body: some View {
        VStack(spacing: 16) {
            Text("Create Account")
                .bold()
                .padding(.bottom, 16)
            
            VStack(spacing: 16) {
                nameTextField
                
                emailTextField
                
                passwordSecureField
                
//                TextField(text: $userValidator.name) {
//                    Text("Name")
//                }
//                .padding()
//                .background(.background) // Dark mode support
//                .clipShape(.rect(cornerRadius: 4))
//                .autocorrectionDisabled()
//                .textInputAutocapitalization(.words)
//                .focused($focusedField, equals: .nameField)
//                .onTapGesture {
//                    focusedField = .nameField
//                }
//                .onSubmit {
//                    focusedField = .emailField
//                }
//                .submitLabel(.next)
//                .textContentType(.name)
//
//                TextField(text: $userValidator.email) {
//                    Text("Email")
//                }
//                .padding()
//                .background(.background) // Dark mode support
//                .clipShape(.rect(cornerRadius: 4))
//
//                .autocorrectionDisabled()
//                .keyboardType(.emailAddress)
//                .focused($focusedField, equals: .emailField)
//                .onTapGesture {
//                    focusedField = .emailField
//                }
//                .submitLabel(.next)
//                .onSubmit {
//                    focusedField = .passwordField
//                }
//                .textContentType(.emailAddress)
//
//                SecureField(text: $userValidator.password) {
//                    Text("Password")
//                }
//                .padding()
//                .background(.background) // Dark mode support
//                .clipShape(.rect(cornerRadius: 4))
//                .contentShape(RoundedRectangle(cornerRadius: 5))
//                .focused($focusedField, equals: .passwordField)
//                .onTapGesture {
//                    focusedField = .passwordField
//                }
//                .onSubmit {
//                    createAccount()
//                }
//                .textContentType(.newPassword)
            }
            Button {
                createAccount()
            } label: {
                Group {
                    if !userValidator.processing {
                        Text("Create Account")
                            .bold()
                    } else {
                        ProgressView()
                        
                    }
                }
                .frame(minWidth: 200)
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
    
    
    // MARK: Views

//    var nameTextField: some View {
//        CustomTextField(text: $userValidator.name, placeholder: "Name", focus: .nameField, focusedField: focusedField)
//            .focused($focusedField, equals: .nameField)
//            .textInputAutocapitalization(.words)
//            .textContentType(.name)
//    }
//
//    var emailTextField: some View {
//        CustomTextField(text: $userValidator.email, placeholder: "Email", focus: .emailField, focusedField: focusedField)
//            .focused($focusedField, equals: .emailField)
//            .keyboardType(.emailAddress)
//            .textContentType(.emailAddress)
//    }

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
    
    // MARK: Methods
    
    func createAccount() {
        // TODO: Warn user if input is empty (reader exercise)
        
        if !userValidator.isSubmitButtonDisabled {
            focusedField = nil
            userValidator.createAccount()
        } else {
            print("Error: Please enter valid name, email, and 8+ character password")
        }
    }
}


#Preview {
//    @Previewable @State var userValidator = UserValidator() // iOS 18 only
//    LogInView(userValidator: userValidator)

    LogInView(userValidator: UserValidator()) // iOS 17
}
