//
//  BudgetWidget.swift
//  BudgetWidget
//
//  Created by Paul Solt on 6/1/25.
//

import WidgetKit
import SwiftUI
import Charts

// UI
// 1. Layout
// 2. View Model
// 3. Chart
// 4. Design

struct DailyBudget: Identifiable {
    let id = UUID()
    var day: Date
    var amount: Double
}

@Observable
class BudgetViewModel {
    var days: [DailyBudget] = []
    var dailyLimit: Double = 80
    var weeklyLimit: Double = 425

    let threshold: Double = 0.8 // 80%

    init() {
        days = createDailyBudget()
//        print(days.count)
    }

    func createDailyBudget() -> [DailyBudget] {
        let weekDays = currentWeekDays(.now)
        let amounts: [Double] = [34, 89, 15, 43, 69, 50, 0] // > $80

        let budget = zip(weekDays, amounts).map { day, amount in
            DailyBudget(day: day, amount: amount)
        }
        return budget
    }

    func currentWeekDays(_ date: Date) -> [Date] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2 // 2 == Monday, 1 == Sunday

        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: date) else {
            fatalError("Unable to create week interval")
        }
        let startDay = weekInterval.start
        let days: [Date] = (0 ..< 7).compactMap { day in
            calendar.date(byAdding: .day, value: day, to: startDay)
        }
        return days
    }

    func colorForAmount(_ amount: Double) -> Color {
        if amount <= threshold * dailyLimit {
            return .blue
        } else if amount > threshold * dailyLimit && amount <= dailyLimit {
            return .orange
        } else { // amount > dailyLimit
            return .red
        }
    }

    func remainder() -> Double {
        var total = weeklyLimit
        for day in days {
            total -= day.amount
        }
        return total
    }
}

struct BudgetWidgetEntryView : View {
    @State var viewModel = BudgetViewModel()
    let barWidth: CGFloat = 6

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(viewModel.remainder(), format: .currency(code: "USD").precision(.fractionLength(0)))
                .font(.system(size: 30, weight: .black, design: .rounded))
                .minimumScaleFactor(0.6)

            Text("Remaining this week")
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(.secondary)

            Spacer()

            Chart {
                // Background bar fill
                ForEach(viewModel.days) { day in
                    BarMark(
                        x: .value("Day", day.day),
                        y: .value("Amount", viewModel.dailyLimit),
                        width: .fixed(barWidth),
                        height: .fixed(viewModel.dailyLimit),
                        stacking: .standard
                    )
                    .foregroundStyle(.gray.quaternary)
                    .clipShape(.capsule)
                }

                // Data fill
                ForEach(viewModel.days) { day in
                    BarMark(
                        x: .value("Day", day.day),
                        y: .value("Amount", min(day.amount, viewModel.dailyLimit)),
                        width: .fixed(barWidth),
                        height: .fixed(viewModel.dailyLimit),
                        stacking: .unstacked
                    )
                    .clipShape(.capsule)
                    .foregroundStyle(viewModel.colorForAmount(day.amount))
                }
            }
            .chartYScale(domain: [0, viewModel.dailyLimit])
            .chartXAxis {
                AxisMarks(
                    format: Date.FormatStyle().weekday(.narrow),
                    preset: .aligned,
                    position: .bottom,
                    values: .automatic(desiredCount: 7),
                    stroke: .init(lineWidth: 0)
                )
            }
            .chartYAxis {
                AxisMarks(
                    preset: .automatic,
                    position: .leading,
                    values: [0, viewModel.dailyLimit]
                ) { value in
                    AxisValueLabel {
                        if let number = value.as(Double.self) {
                            Text(number, format: .currency(code: "USD").precision(.fractionLength(0)))
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(Color.primary)
                                .padding(.trailing, 8)
                        }
                    }
                }
            }
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
