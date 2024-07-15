//
//  UserValidator.swift
//  LogInCombine
//
//  Created by Paul Solt on 7/15/24.
//

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
