//
//  UserValidator.swift
//  LogInObservation-End
//
//  Created by Paul Solt on 7/15/24.
//

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
