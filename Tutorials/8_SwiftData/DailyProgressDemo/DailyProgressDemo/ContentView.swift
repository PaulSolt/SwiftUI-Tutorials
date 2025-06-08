//
//  ContentView.swift
//  DailyProgressDemo
//
//  Created by Paul Solt on 8/1/24.
//

import SwiftUI
import SwiftData



@Model
class DailyProgress: Identifiable, CustomStringConvertible {
    var id = UUID()
    var date: Date
    var goal: Int
    var task: TaskModel?
    
    init(date: Date, goal: Int) {
        self.date = date
        self.goal = goal
    }
    
    var description: String {
        "\(date) - \(goal)"
    }
    
    var weekOfYear: Int {
        let calendar = Calendar.autoupdatingCurrent
        return calendar.component(.weekOfYear, from: date)
    }
    
    var yearForWeekOfYear: Int {
        let calendar = Calendar.autoupdatingCurrent
        return calendar.component(.yearForWeekOfYear, from: date)
    }
}

@Model
class TaskModel: Identifiable {
    @Attribute(.unique) var id = UUID().uuidString
    var name: String
    var goal: Int
    
    @Relationship(deleteRule: .cascade)
    var progress: [DailyProgress] = []
        
    
    
    init(name: String, goal: Int) {
        self.name = name
        self.goal = goal
    }
    
    func goalForDate(_ date: Date) -> Int {
        let calendar = Calendar.autoupdatingCurrent
        for dailyProgress in progress {
            if calendar.isDate(dailyProgress.date, inSameDayAs: date) {
                return dailyProgress.goal
            }
        }
        return 0
    }
    
    @MainActor
    func updateGoal(date: Date, value: Int) {
        let calendar = Calendar.autoupdatingCurrent
        let dateIndex = progress.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: date) })
        
        if let index = dateIndex {
            progress[index].goal += value
            if progress[index].goal <= 0 {
                progress.remove(at: index)
            }
        } else if value > 0 {
            let newProgress = DailyProgress(date: date, goal: value)
            progress.append(newProgress)
        }
    }
}

struct ContentView: View {
    @Query private var tasks: [TaskModel]
    @State private var selectedTask: TaskModel?
    @State private var showingNewTaskSheet = false
    
    var body: some View {
        NavigationView {
            List(tasks) { task in
                TaskRow(task: task)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedTask = task
                    }
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingNewTaskSheet = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(item: $selectedTask) {
                TaskDetailView(task: $0)
            }
            .sheet(isPresented: $showingNewTaskSheet) {
                NewTaskView(isPresented: $showingNewTaskSheet)
            }
        }
    }
}

struct TaskRow: View {
    let task: TaskModel
    
    
    
    var body: some View {
        HStack {
            Text(task.name)
            Spacer()
            Text("Goal: \(task.goal)")
                .foregroundColor(.secondary)
        }
    }
}

struct TaskDetailView: View {
    @Bindable var task: TaskModel
    @Environment(\.modelContext) private var modelContext
    @State private var today = Date()
    
    @Query var progresses: [DailyProgress]

    init(task: TaskModel) {
       let predicate = #Predicate<DailyProgress> {
   $0.task == task
       }
       _progresses = Query(filter: predicate, sort: \ DailyProgress.date)
   }

    var todayTotal: Int {
        task.goalForDate(Date())
    }
    
    var body: some View {
        Form {
            Section(header: Text("Task Details")) {
                TextField("Task Name", text: $task.name)
                Stepper("Daily Goal: \(task.goal)", value: $task.goal, in: 1...100)
            }
            
            Section(header:                 Text("Total: \(todayTotal)")) {
                Text("Total: \(task.goalForDate(today))")
                Button(action: {
                    task.updateGoal(date: today, value: 1)
                }) {
                    Label("Log Progress", systemImage: "plus.circle")
                }
            }
            
//            Section(header: Text("All Progresses")) {
//                if task.progress.isEmpty {
//                    Text("No progress logged yet")
//                        .foregroundColor(.secondary)
//                } else {
//                    ForEach(task.progress.sorted(by: { $0.date > $1.date })) { progress in
//                        HStack {
//                            Text(progress.date, style: .date)
//                            Spacer()
//                            Text("Goal: \(progress.goal)")
//                        }
//                    }
//                }
//            }
        }
        .navigationTitle("Task Details")
    }
}

struct NewTaskView: View {
    @Environment(\.dismiss) private var dismiss

    @Environment(\.modelContext) private var modelContext

    @Binding var isPresented: Bool
    
    @State private var taskName = ""
    @State private var goal = 1
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Task Name", text: $taskName)
                Stepper("Daily Goal: \(goal)", value: $goal, in: 1...100)
            }
            .navigationTitle("New Task")
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false
                },
                trailing: Button("Save") {
                    modelContext.insert(TaskModel(name: taskName, goal: goal))
                    isPresented = false
                }
                .disabled(taskName.isEmpty)
            )
        }
    }
}

//
//struct ContentView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Query private var items: [Item]
//
//    var body: some View {
//        NavigationSplitView {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
//                    } label: {
//                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//        } detail: {
//            Text("Select an item")
//        }
//    }
//
//    private func addItem() {
//        withAnimation {
//            let newItem = Item(timestamp: Date())
//            modelContext.insert(newItem)
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                modelContext.delete(items[index])
//            }
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
//}
