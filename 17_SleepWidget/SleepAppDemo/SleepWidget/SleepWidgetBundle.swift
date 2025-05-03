//
//  SleepWidgetBundle.swift
//  SleepWidget
//
//  Created by Paul Solt on 5/3/25.
//

import WidgetKit
import SwiftUI

@main
struct SleepWidgetBundle: WidgetBundle {
    var body: some Widget {
        SleepWidget()
        SleepWidgetControl()
    }
}
