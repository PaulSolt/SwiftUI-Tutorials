//
//  BoardingWidgetBundle.swift
//  BoardingWidget
//
//  Created by Paul Solt on 10/14/24.
//

import WidgetKit
import SwiftUI

@main
struct BoardingWidgetBundle: WidgetBundle {
    var body: some Widget {
        BoardingWidget()
        BoardingWidgetControl()
        BoardingWidgetLiveActivity()
    }
}
