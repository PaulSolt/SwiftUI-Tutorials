//
//  SleepWidget.swift
//  SleepWidget
//
//  Created by Paul Solt on 5/5/25.
//

import WidgetKit
import SwiftUI


// UI
// 1. Layout
// 2. Design
// 3. Cleanup

struct SleepWidgetEntryView : View {
    var body: some View {
        VStack {
            // TODO: Insert UI here
            Text("Start")
        }
    }
}

struct SleepWidget: Widget {
    let kind: String = "SleepWidget"

    // TODO: Update background here

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            SleepWidgetEntryView()
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}


#Preview(as: .systemSmall) {
    SleepWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
}
