//
//  LogInCombineApp.swift
//  LogInCombine
//
//  Created by Paul Solt on 7/14/24.
//

import SwiftUI

@main
struct LogInCombineApp: App {
    @State var userValidator = UserValidator()
    
    var body: some Scene {
        WindowGroup {
            LogInView(userValidator: userValidator)
        }
    }
}
