//
//  ChartsWidget.swift
//  ChartsWidget
//
//  Created by Paul Solt on 5/31/25.
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
    var day: Date // String // = "M"
    var amount: Double // $45.33 // Ideally use Decimal
}

@Observable
class BudgetViewModel {

    var days: [DailyBudget] = []
    var dailyLimit: Double = 80
    var weeklyLimit: Double = 425
    let threshold = 0.8 // >80% of daily limit is warning

    init() {
        days = createDailyBudget()
    }

    func createDailyBudget() -> [DailyBudget] {

        let weekDays = currentWeekDays(.now)
        let amounts: [Double] = [44, 59, 30, 48, 69, 50, 0] // Try: > $80 to see RED

        let budget = zip(weekDays, amounts).map { day, amount in
            DailyBudget(day: day, amount: amount)
        }
       return budget
    }

    func currentWeekDays(_ date: Date) -> [Date] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2 // 2 == Monday as first day of week

        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: date) else {
            fatalError("Unable to calculate first day of week for date: \(date)")
        }

        let mondayOfThisWeek = weekInterval.start
        let sevenDays: [Date] =  (0 ..< 7).compactMap { days in
            calendar.date(byAdding: .day, value: days, to: mondayOfThisWeek)
        }
        return sevenDays
    }

    func remainder() -> Double {
        var total = weeklyLimit
        for day in days {
            total -= day.amount
        }
        return total
    }

    func colorForAmount(_ amount: Double) -> Color {
        if amount < threshold * dailyLimit {
            return Color.blue
        } else if amount >= threshold * dailyLimit && amount <= dailyLimit {
            return Color.orange
        } else { // amount > dailyLimit
            return Color.red
        }
    }
}

//    @Environment(\.widgetFamily) var widgetFamily // Future variants

struct ChartsWidgetEntryView : View {
    @State var viewModel: BudgetViewModel = BudgetViewModel()

    var barWidth: CGFloat = 6
    let currencyFormatter = FloatingPointFormatStyle<Double>.Currency(code: "USD")
        .precision(.fractionLength(0))

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(viewModel.remainder(), format: currencyFormatter) // $125
                .font(.system(size: 30, weight: .black, design: .rounded))

            Text("Remaining this week")
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(.secondary)

            Spacer(minLength: 15)

            // Chart BudgetLimit vs. Days abbrieviated

            Chart {
                /// Background bar fill
                ForEach(viewModel.days) { day in
                    BarMark(
                        x: .value("Day", day.day),
                        y: .value("Amount", viewModel.dailyLimit),
                        width: .fixed(barWidth),
                        height: .fixed(CGFloat(viewModel.dailyLimit)),
                        stacking: .standard
                    )
                    .foregroundStyle(.gray.quaternary)
                    .clipShape(Capsule())
                }

                // Data bar fill
                ForEach(viewModel.days) { day in
                    BarMark(
                        x: .value("Day", day.day),
                        y: .value("Budget", min(day.amount, viewModel.dailyLimit)), // LIMIT Height
                        width: .fixed(barWidth),
                        height: .fixed(CGFloat(viewModel.dailyLimit)),
                        stacking: .unstacked
                    )
                    .foregroundStyle(viewModel.colorForAmount(day.amount).gradient)
                    .clipShape(Capsule())
                }
            }
            //            .chartXAxis { // Nothing == Hide everything
            //            }
            .chartXAxis {
                AxisMarks(
                    format: Date.FormatStyle().weekday(.narrow),
                    preset: .aligned,
                    position: .bottom,
                    values: .automatic(desiredCount: 7),
                    stroke: .init(lineWidth: 0))
            }
//            .chartYAxis {
//                AxisMarks(
//                    format: .currency(code: "USD").precision(.fractionLength(0)),
//                    preset: .aligned,
//                    position: .leading,
//                    values: [0, viewModel.dailyLimit],
//                    stroke: .init(lineWidth: 0) // Hide horizontal axis
//                )
//            }
            .chartYAxis {
                AxisMarks(
                    position: .leading,
                    values: [0, viewModel.dailyLimit]
                ) { value in
                    AxisValueLabel {
                        if let number = value.as(Double.self) {
                            Text(number, format: currencyFormatter)
                                .font(.system(size: 10, weight: .bold))
                                .padding(.trailing, 4)
                                .foregroundStyle(Color.primary)
                        }
                    }

                }
            }
            .chartYScale(domain: [0, viewModel.dailyLimit])
        }
    }
}

struct ChartsWidget: Widget {
    let kind: String = "ChartsWidget"

    let c = Color(red: 235 / 255, green: 25 / 255, blue: 75 / 255)

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ChartsWidgetEntryView()
                .containerBackground(.background, for: .widget)
        }
        .configurationDisplayName("Budget")
        .description("My weekly spending budget.")
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
    ChartsWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
}
