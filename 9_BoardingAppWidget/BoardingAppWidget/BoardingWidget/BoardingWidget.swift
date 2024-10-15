//
//  BoardingWidget.swift
//  BoardingWidget
//
//  Created by Paul Solt on 10/14/24.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct BoardingWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "airplane")
                VStack(alignment: .leading) {
                    Text("BR521")
                        .font(.system(size: 12, weight: .semibold))
                    Text("to Dubai")
                        .font(.system(size: 12, weight: .medium))
                        .opacity(0.4)
                }
                Spacer()
            }
            Spacer()
            
            VStack(alignment: .leading, spacing: -4) {
                Text("your gate is")
                    .opacity(0.4)
                    .font(.system(size: 12, weight: .medium))
                Text("B32")
                    .font(.system(size: 40, weight: .bold))
                Text("Boarding: Group B")
                    .font(.system(size: 12, weight: .medium))
            }
        }
        .padding(20)
    }
}

let yellow = Color(red: 255.0 / 255.0, green: 220.0 / 255.0, blue: 6.0 / 255.0)

struct BoardingWidget: Widget {
    let kind: String = "BoardingWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            BoardingWidgetEntryView(entry: entry)
                .containerBackground(for: .widget) {
                    Color.black
                    
                    ContainerRelativeShape()
                        .inset(by: 4)
                        .fill(yellow)
                }
//                .contentMargins(0)
//                .margin
        }
        .contentMarginsDisabled()
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    BoardingWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
