//
//  SleepWidget.swift
//  SleepWidget
//
//  Created by Paul Solt on 5/5/25.
//

import WidgetKit
import SwiftUI
import Foundation

// UI
// 1. Layout
// 2. Design
// 3. Cleanup

@Observable
class SleepViewModel {

    var sleepMessage: AttributedString = ""
    var motivationMessage: AttributedString = ""

    init(hours: Double) {
        // Force a language on 2nd run
    //        UserDefaults.standard.set(["en"], forKey: "AppleLanguages")

        let sleepDuration = Measurement(value: hours, unit: UnitDuration.hours)
            .formatted(.measurement(width: .narrow))
        let sleep = String(localized: "sleep.highlight", defaultValue: "sleep")
        let rest = String(localized: "rest.highlight", defaultValue: "rest")

        // Less than 6 hours
        let message = String(localized: "Less than \(sleepDuration) of \(sleep) today.")
        let motivation = String(localized: "Get some \(rest)!")

        // >= 6 hours and < 9 hours

        // >= 9 hours

        // highlight text [sleepDuration, sleep]
        sleepMessage = highlightAttributedString(message: message, highlights: [sleepDuration, sleep])
        motivationMessage = highlightAttributedString(message: motivation, highlights: [rest])
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

struct SleepWidgetEntryView : View {

    @State var viewModel = SleepViewModel(hours: 5)

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(systemName: "moon.fill")
                .foregroundStyle(.primary)

            Spacer(minLength: 0)

            Text(viewModel.sleepMessage)

            Spacer(minLength: 0)

            Text(viewModel.motivationMessage)
        }
        .foregroundStyle(.secondary)
        .colorScheme(.dark)
        .font(.system(size: 18, weight: .bold))
        .minimumScaleFactor(0.8)
    }
}

struct SleepWidget: Widget {
    let kind: String = "SleepWidget"

    let lightPurple = Color(red: 120 / 255, green: 49 / 255, blue: 239 / 255)
    let darkPurple = Color(red: 130 / 255, green: 64 / 255, blue: 234 / 255)
    let light = Color(red: 194 / 255, green: 163 / 255, blue: 241 / 255)

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            SleepWidgetEntryView()
//                .environment(\.locale, .init(identifier: "es"))

//                .containerBackground(.purple.gradient, for: .widget)
//                .containerBackground(gradient, for: .widget)
                .containerBackground(meshGradient2, for: .widget)
        }
        .configurationDisplayName("Sleep Tracker")
        .description("See how much sleep you ")
        .supportedFamilies([.systemSmall])
//        .disfavoredLocations([.lockScreen, .homeScreen], for: [.systemSmall])
    }

    var gradient: some ShapeStyle {
        LinearGradient(colors: [lightPurple, darkPurple], startPoint: .top, endPoint: .bottom)
            .shadow(.inner(color: .white.opacity(0.2), radius: 15, x: 0, y: -5))
    }

    var meshGradient: some ShapeStyle {
        MeshGradient(width: 3, height: 3, points: [
            .init(x: 0, y: 0), .init(x: 0.5, y: 0), .init(x: 1, y: 0),
            .init(x: 0, y: 0.5), .init(x: 0.5, y: 0.5), .init(x: 1, y: 0.5),
            .init(x: 0, y: 1), .init(x: 0.5, y: 1), .init(x: 1, y: 1),
        ], colors: [
            darkPurple, darkPurple, lightPurple,
            darkPurple, lightPurple, darkPurple,
            lightPurple, lightPurple, lightPurple
        ])
        .shadow(.inner(color: .white.opacity(0.2), radius: 15, x: 0, y: -5))
    }

    // More colors mixing for thumbnail
    var meshGradient2: some ShapeStyle {
        MeshGradient(width: 3, height: 3, points: [
            .init(x: 0, y: 0), .init(x: 0.5, y: 0), .init(x: 1, y: 0),
            .init(x: 0, y: 0.5), .init(x: 0.5, y: 0.5), .init(x: 1, y: 0.5),
            .init(x: 0, y: 1), .init(x: 0.5, y: 1), .init(x: 1, y: 1),
        ], colors: [
            darkPurple, darkPurple, light.mix(with: lightPurple, by: 0.5),
            darkPurple, lightPurple.mix(with: light, by: 0.3), darkPurple,
            light.mix(with: darkPurple, by: 0.5), lightPurple, light.mix(with: darkPurple, by: 0.5)
        ])
//        .shadow(.inner(color: .white.opacity(0.2), radius: 15, x: 0, y: -5))
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

// Force Preview to use English
#Preview("English", as: .systemSmall) {
    UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
    return SleepWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
}

// Force Preview to use Spanish
#Preview("Spanish", as: .systemSmall) {
    UserDefaults.standard.set(["es"], forKey: "AppleLanguages")
    return SleepWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
}


// Does not work!
//struct Previews: PreviewProvider {
//    static var previews: some View {
//
//        SleepWidgetEntryView()
//            .environment(\.locale, Locale(identifier: "es"))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//            .containerBackground(for: .widget) {
//                Color.blue
//            }
//    }
//}


//#Preview("English (systemSmall)", as: .systemSmall) {
//    SleepWidget()
////    SleepWidgetEntryView() //entry: .init(date: .now, emoji: "😀"))
////        .environment(\.locale, .init(identifier: "en"))
////        .previewContext(WidgetPreviewContext(family: .systemSmall))
//} timeline: {
//    SimpleEntry(date: .now, emoji: "D")
//}

//#Preview("Spanish (systemSmall)", as: .systemSmall) {
//    SleepWidgetEntryView(entry: .init(date: .now, emoji: "😀"))
//        .environment(\.locale, .init(identifier: "es"))
//        .previewContext(WidgetPreviewContext(family: .systemSmall))
//}


//#Preview("German", as: .systemSmall) {
//    UserDefaults.standard.set(["ge"], forKey: "AppleLanguages")
//    return SleepWidget()
//} timeline: {
//    SimpleEntry(date: .now, emoji: "😀")
//}


