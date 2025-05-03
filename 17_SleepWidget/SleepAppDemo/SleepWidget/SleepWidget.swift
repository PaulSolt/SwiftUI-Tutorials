//
//  SleepWidget.swift
//  SleepWidget
//
//  Created by Paul Solt on 5/3/25.
//

import WidgetKit
import SwiftUI

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

struct SleepFeedback: View {
    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: "moon.fill")
                .foregroundStyle(.primary)
                .imageScale(.medium)

            Spacer(minLength: 0)

            VStack(alignment: .leading, spacing: 0) {
                Text("Less than ") +
                Text("4h").foregroundStyle(.primary) +
                Text(" of ") +
                Text("sleep").foregroundStyle(.primary) +
                Text(" today.")
            }

            Spacer(minLength: 0)

            VStack(spacing: 0) {
                Text("Get some ") +
                Text("rest").foregroundStyle(.primary) +
                Text("!")
            }
        }
        .foregroundStyle(.secondary)
        .font(Font.system(size: 18, weight: .bold))
        .colorScheme(.dark) // Force dark mode
    }
}

struct SleepWidget: Widget {
    let kind: String = "SleepWidget"

    let darkBlue = Color(red: 120 / 255, green: 49 / 255, blue: 239 / 255)
    let lightBlue = Color(red: 130 / 255, green: 64 / 255, blue: 234 / 255)

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in

            SleepFeedback()
                .containerBackground(
                    backgroundBlue,
//                    meshBlue,
//                    .blue.gradient,
                    for: .widget
                )
        }
        .configurationDisplayName("Poor Sleep")
        .description("You got too little sleep")
    }

    // EXTRA
    var backgroundBlue: some ShapeStyle {
        LinearGradient(
            colors: [lightBlue, darkBlue],
            startPoint: .top,
            endPoint: .bottom
        )
        .shadow(.inner(color: .white.opacity(0.3), radius: 15, x: 0, y: 0))
    }

    var meshBlue: MeshGradient {
        return
            MeshGradient(width: 3, height: 3, points: [
                .init(0, 0), .init(0.5, 0), .init(1, 0),
                .init(0, 0.5), .init(0.5, 0.5), .init(1, 0.5),
                .init(0, 1), .init(0.5, 1), .init(1, 1)
            ], colors: [
                darkBlue, darkBlue, lightBlue,
                darkBlue, lightBlue, darkBlue,
                lightBlue, lightBlue, lightBlue,
            ])
    }
}

#Preview(as: .systemSmall) {
    SleepWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "🤩")
}
