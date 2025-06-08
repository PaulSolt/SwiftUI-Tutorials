//
//  SleepWidget.swift
//  SleepWidget
//
//  Created by Paul Solt on 5/3/25.
//

import WidgetKit
import SwiftUI

@Observable
class SleepViewModel {

    var sleepMessage: AttributedString = ""
    var motivationMessage: AttributedString = ""

    init(hours: Double) {
        // Dynamic pieces: “4h”, “sleep”, “rest”
        let sleepDuration = Measurement(value: hours, unit: UnitDuration.hours)
            .formatted(.measurement(width: .narrow))
        let sleep = "sleep"
        let rest = "rest"

        // if sleep < 6 hours
        let message = "Less than \(sleepDuration) of \(sleep) today"
        let messageHighlights = [sleepDuration, sleep]
        let motivation = "Get some \(rest)!"
        let motivationHighlights = [rest]

        // if sleep >= 6 && sleep <= 8 ...

        sleepMessage = highlightAttributedString(message: message, highlights: messageHighlights)
        motivationMessage = highlightAttributedString(message: motivation, highlights: motivationHighlights)
    }

    func highlightAttributedString(message: String, highlights: [String]) -> AttributedString {
        var attributedMessage = AttributedString(message)
        attributedMessage.foregroundColor = .secondary

        for word in highlights {
            if let range = attributedMessage.range(of: word) {
                attributedMessage[range].foregroundColor = .primary
            }
        }
        return attributedMessage
    }
}

struct SleepFeedback: View {
    let viewModel: SleepViewModel = SleepViewModel(hours: 4)

    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: "moon.fill")
                .foregroundStyle(.primary)
                .imageScale(.medium)

            Spacer(minLength: 0)

//            VStack(alignment: .leading, spacing: 0) {
//                Text("Less than ") +
//                Text("4h").foregroundStyle(.primary) +
//                Text(" of ") +
//                Text("sleep").foregroundStyle(.primary) +
//                Text(" today.")
//            }
            Text(viewModel.sleepMessage)

            Spacer(minLength: 0)

//            VStack(spacing: 0) {
//                Text("Get some ") +
//                Text("rest").foregroundStyle(.primary) +
//                Text("!")
//            }
            Text(viewModel.motivationMessage)
        }
        .foregroundStyle(.secondary)
        .font(Font.system(size: 18, weight: .bold))
        .colorScheme(.dark) // Force dark mode
    }
}

struct SleepWidget: Widget {
    let kind: String = "SleepWidget"

    let lightPurple = Color(red: 120 / 255, green: 49 / 255, blue: 239 / 255)
    let darkPurple = Color(red: 130 / 255, green: 64 / 255, blue: 234 / 255)

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            SleepFeedback()
//                .containerBackground(.purple.gradient, for: .widget)
//                .containerBackground(gradient, for: .widget)
                .containerBackground(meshGradient, for: .widget)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }

    var gradient: some ShapeStyle {
        LinearGradient(colors: [lightPurple, darkPurple], startPoint: .top, endPoint: .bottom)
            .shadow(.inner(color: .white.opacity(0.5), radius: 15, x: 0, y: -5))
    }

    var meshGradient: some ShapeStyle {
        MeshGradient(width: 3, height: 3, points: [
            .init(x: 0, y: 0), .init(x: 0.5, y: 0), .init(x: 1.0, y: 0),
            .init(x: 0, y: 0.5), .init(x: 0.5, y: 0.5), .init(x: 1.0, y: 0.5),
            .init(x: 0, y: 1), .init(x: 0.5, y: 1), .init(x: 1.0, y: 1),
        ], colors: [
            darkPurple, darkPurple, lightPurple,
            darkPurple, lightPurple, darkPurple,
            darkPurple, darkPurple, darkPurple
        ])
        .shadow(.inner(color: .white.opacity(0.2), radius: 15, x: 0, y: -5))
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
    SleepWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "🤩")
}
