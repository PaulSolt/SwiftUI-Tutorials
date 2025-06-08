//
//  BudgetWidget.swift
//  BudgetWidget
//
//  Created by Paul Solt on 6/1/25.
//

import WidgetKit
import SwiftUI

// UI
// 1. Layout
// 2. View Model
// 3. Chart
// 4. Design

struct BudgetWidgetEntryView : View {

    var body: some View {
        VStack {
            Text("Budget")
        }
    }
}

struct BudgetWidget: Widget {
    let kind: String = "BudgetWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            BudgetWidgetEntryView()
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

}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}


#Preview(as: .systemSmall) {
    BudgetWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "🤩")
}
