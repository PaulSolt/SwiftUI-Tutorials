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
                
                TextField(text: $userValidator.name) {
                    Text("Name")
                }
                .autocorrectionDisabled()
                .textInputAutocapitalization(.words)
                .focused($focusedField, equals: .name)
                .padding()
                .background(.background) // Dark mode support
                .clipShape(.rect(cornerRadius: 4))
                .onTapGesture {
                    focusedField = .name
                }
                .textContentType(.name)
                .submitLabel(.next)
                .onSubmit {
                    focusedField = .email
                }
                
                TextField(text: $userValidator.email) {
                    Text("Email")
                }
                .autocorrectionDisabled()
                .keyboardType(.emailAddress)
                .focused($focusedField, equals: .email)
                .padding()
                .background(.background) // Dark mode support
                .clipShape(.rect(cornerRadius: 4))
                .onTapGesture {
                    focusedField = .email
                }
                .textContentType(.emailAddress)
                .submitLabel(.next)
                .onSubmit {
                    focusedField = .password
                }
                
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
        .padding(40)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(4)
        .padding(20)
        .onAppear {
            focusedField = .name
        }
    }
    
    func createAccount() {
        if !userValidator.isSubmitButtonDisabled {
            userValidator.createAccount()
        } else {
            print("Error: Please enter a valid name, email, and 8+ character password")
        }
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
