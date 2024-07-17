//
//  LogInView.swift
//  LogInObservation-End
//
//  Created by Paul Solt on 7/15/24.
//

import SwiftUI

enum LogInFocus: Int, Hashable {
    case name, email, password
}

struct LogInView: View {
    @Bindable var userValidator: UserValidator
    @FocusState var focusedField: LogInFocus?
    
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
            
            createAccountButton
        }
        .padding(40)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(4)
        .padding(20)
        .onAppear {
            focusedField = .name
        }
    }
   
    // MARK: Views
    
    var nameTextField: some View {
        CustomTextField(text: $userValidator.name, placeholder: "Name", focus: .name, focusedField: focusedField)
            .textInputAutocapitalization(.words)
            .focused($focusedField, equals: .name)
            .textContentType(.name)
            .submitLabel(.next)
            .onSubmit {
                focusedField = .email
            }
    }
    
    var emailTextField: some View {
        CustomTextField(text: $userValidator.email, placeholder: "Email", focus: .email, focusedField: focusedField)
            .keyboardType(.emailAddress)
            .focused($focusedField, equals: .email)
            .textContentType(.emailAddress)
            .submitLabel(.next)
            .onSubmit {
                focusedField = .password
            }
    }
    
    var passwordSecureField: some View {
        SecureField(text: $userValidator.password) {
            Text("Password")
        }
        .onSubmit {
            createAccount()
        }
        .focused($focusedField, equals: .password)
        .padding()
        .background(.background) // Dark mode support
        .clipShape(.rect(cornerRadius: 4))
        .onTapGesture {
            focusedField = .password
        }
        .textContentType(.newPassword)
        .submitLabel(.continue)
    }
    
    var createAccountButton: some View {
        Button {
            createAccount()
        } label: {
            Group {
                if userValidator.isCreatingAccount {
                    ProgressView()
                } else {
                    Text("Create Account")
                        .bold()
                }
            }
            .frame(minWidth: 200)
        }
        .disabled(userValidator.isSubmitButtonDisabled)
        .padding(.top, 16)
        .buttonStyle(.borderedProminent)
        .keyboardShortcut(.defaultAction)
    }
    
    // MARK: Methods
    
    func createAccount() {
        if !userValidator.isSubmitButtonDisabled {
            userValidator.createAccount()
        } else {
            print("Error: Please enter a valid name, email, and 8+ character password")
        }
    }
}

#Preview {
    LogInView(userValidator: UserValidator())
}
