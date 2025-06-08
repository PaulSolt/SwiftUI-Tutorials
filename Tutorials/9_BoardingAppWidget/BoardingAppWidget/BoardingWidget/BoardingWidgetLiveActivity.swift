//
//  BoardingWidgetLiveActivity.swift
//  BoardingWidget
//
//  Created by Paul Solt on 10/14/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct BoardingWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct BoardingWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: BoardingWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension BoardingWidgetAttributes {
    fileprivate static var preview: BoardingWidgetAttributes {
        BoardingWidgetAttributes(name: "World")
    }
}

extension BoardingWidgetAttributes.ContentState {
    fileprivate static var smiley: BoardingWidgetAttributes.ContentState {
        BoardingWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: BoardingWidgetAttributes.ContentState {
         BoardingWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: BoardingWidgetAttributes.preview) {
   BoardingWidgetLiveActivity()
} contentStates: {
    BoardingWidgetAttributes.ContentState.smiley
    BoardingWidgetAttributes.ContentState.starEyes
}
