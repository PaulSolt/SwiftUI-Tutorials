//
//  LogInObservation_EndApp.swift
//  LogInObservation-End
//
//  Created by Paul Solt on 7/15/24.
//

import SwiftUI

@main
struct LogInObservation_EndApp: App {
    @State var userValidator = UserValidator()
    
    var body: some Scene {
        WindowGroup {
            LogInView(userValidator: userValidator)
        }
    }
}
