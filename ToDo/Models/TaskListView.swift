//
//  TaskListView.swift
//  ToDo
//
//  Created by Admin Pro on 12/31/24.
//

import SwiftUI

struct TaskListView: View {
    @Binding var tasks: [Task]
    @Binding var showEdit: Bool
    var deleteTask: (Task) -> Void
    var toggleTaskCompletion: (Task) -> Void
    
    @State private var currentDate = Date()
    
    var body: some View {
        GeometryReader{ geometry in
            ScrollView {
                
                    if tasks.isEmpty {
                        VStack(alignment: .center, spacing: 10) {
                            Text("No Tasks")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                HStack {
                                    Image(systemName: "pencil")
                                        .foregroundColor(.blue)
                                    Text("Tap on")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .opacity(0.8)
                                    Text("Edit")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.blue)
                                }
                                
                                HStack {
                                    Image(systemName: "text.cursor")
                                        .foregroundColor(.blue)
                                    Text("Enter data")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.blue)
                                }
                                
                                HStack {
                                    Image(systemName: "plus.circle")
                                        .foregroundColor(.blue)
                                    Text("Add Task")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.blue)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .padding()
                        
                    }
                
                VStack(spacing: 10) {
                    ForEach(tasks, id: \.id) { task in
                        VStack(alignment: .leading) {
                            HStack {
                                    Text(task.title)
                                        .strikethrough(task.isCompleted, color: .red)
                                        .foregroundColor(task.isCompleted ? .gray : .primary)
                                Spacer()
                                
                                if showEdit {
                                    Button {
                                        withAnimation {
                                            deleteTask(task)
                                        }
                                        print("Task deleted: \(task)")
                                    } label: {
                                        Image(systemName: "minus.circle.fill")
                                            .foregroundColor(.pink)
                                    }
                                }
                                
                                Button {
                                    toggleTaskCompletion(task)
                                } label: {
                                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                }
                                
                            }
                            
                            if let description = task.description {
                                Text(description)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            if let deadline = task.deadline {
                                HStack {
                                    Text("Deadline: \(deadline, formatter: taskDateFormatter)")
                                        .font(.caption)
                                        .foregroundColor(task.isCompleted ? .green : (deadline < currentDate ? .red : .blue))
                                    Spacer()
                                    if task.isCompleted {
                                        Text("Complete!")
                                            .font(.caption)
                                            .foregroundColor(.green)
                                    } else {
                                        if deadline < currentDate {
                                            Text("Overdue")
                                                .font(.caption)
                                                .foregroundColor(.red)
                                        } else {
                                            Text("In: \(formatTimeUntilDeadline(deadline: deadline))")
                                                .font(.caption)
                                                .foregroundColor(.blue)
                                        }
                                    }
                                }
                            }


                            
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .onAppear {
                            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                                currentDate = Date()
                            }
                        }
                    }
                    
                }.frame(width: geometry.size.width-20)
                    .frame(minHeight: 20)
                    .padding(.horizontal, 10)
            }
        }
    }
    private var taskDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
    private func formatTimeUntilDeadline(deadline: Date) -> String {
        let now = currentDate
        if deadline <= now {
            let overdueComponents = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: deadline, to: now)
            return "Overdue by \(overdueComponents.day ?? 0)d \(overdueComponents.hour ?? 0)h \(overdueComponents.minute ?? 0)m \(overdueComponents.second ?? 0)s"
        }
        
        let components = Calendar.current.dateComponents([.year, .month, .weekOfYear, .day, .hour, .minute, .second], from: now, to: deadline)
        
        if let years = components.year, years > 0 {
            return "\(years) year\(years > 1 ? "s" : "")"
        } else if let months = components.month, months > 0 {
            return "\(months) month\(months > 1 ? "s" : "")"
        } else if let weeks = components.weekOfYear, weeks > 0 {
            return "\(weeks) week\(weeks > 1 ? "s" : "")"
        } else if let days = components.day, days > 0 {
            return "\(days) day\(days > 1 ? "s" : "")"
        } else if let hours = components.hour, hours > 0 {
            let minutes = components.minute ?? 0
            return "\(hours)h \(minutes)m"
        } else if let minutes = components.minute, minutes > 0 {
            let seconds = components.second ?? 0
            return "\(minutes)m \(seconds)s"
        } else if let seconds = components.second, seconds > 0 {
            return "\(seconds)s"
        }
        
        return "Now"
    }


}

// MARK: - Preview

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        // iPhone 15 Pro Max iOS 17.2
        TaskListViewPreviewWrapper()
            .preferredColorScheme(.light)
            .previewDisplayName("TaskListView 15 PM Light")
            .previewDevice("iPhone 15 Pro Max")
            .previewLayout(.device)
        
        TaskListViewPreviewWrapper()
            .preferredColorScheme(.dark)
            .previewDisplayName("TaskListView 15 PM Dark")
            .previewDevice("iPhone 15 Pro Max")
            .previewLayout(.device)
        
        // iPhone SE (1st generation) iOS 15.5
        TaskListViewPreviewWrapper()
            .preferredColorScheme(.light)
            .previewDisplayName("TaskListView SE 1Gn Light")
            .previewDevice("iPhone SE (1st generation)")
            .previewLayout(.device)
        
        TaskListViewPreviewWrapper()
            .preferredColorScheme(.dark)
            .previewDisplayName("TaskListView SE 1Gn Dark")
            .previewDevice("iPhone SE (1st generation)")
            .previewLayout(.device)
    }
}

struct TaskListViewPreviewWrapper: View {
    @State private var showSettings = false
    @State private var showEdit = false
    @StateObject private var sampleAppSettings = AppSettings()

    // Tasks state for preview
    @State private var tasks = [
        Task(title: "Sample Task 1", description: "Desc 1", deadline: Date().addingTimeInterval(3600), isCompleted: false),
        Task(title: "Sample Task 2", description: "Desc 2", deadline: Date().addingTimeInterval(7200), isCompleted: true)
    ]
    
    // Notification service
    private var notificationService = NotificationService(tasks: [], reminderEnabled: true)

    var body: some View {
        ZStack {
            Background()
            VStack {
                // Example Header View
                HeaderView(showSettings: $showSettings, helloHeight: .constant(60))
                    .opacity(0) // Placeholder for styling

                // Task Editor View
                TaskEditorView(
                    tasks: $tasks,
                    showEdit: $showEdit,
                    newTaskTitle: .constant("New Task"),
                    saveTasks: {},
                    sortTasks: sortTasks,
                    notificationService: notificationService
                )
                .environmentObject(sampleAppSettings)
                
                // Task List View
                TaskListView(
                    tasks: $tasks,
                    showEdit: $showEdit,
                    deleteTask: deleteTask,
                    toggleTaskCompletion: { task in
                        toggleTaskCompletion(for: task)
                        sortTasks()
                    }
                )
                Spacer()
            }
        }
    }
    
    /// Deletes a task from the list
    private func deleteTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
        sortTasks()
        // Remove notifications for the task
        notificationService.removeNotifications(for: task)
    }
    
    /// Toggles the isCompleted status of a task
    private func toggleTaskCompletion(for task: Task) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        let wasCompleted = tasks[index].isCompleted
        
        tasks[index].isCompleted.toggle()
        
        // Remove notifications for completed tasks
        if tasks[index].isCompleted {
            notificationService.removeNotifications(for: tasks[index])
        }
        // Re-schedule notifications for uncompleted tasks with reminders enabled
        else if wasCompleted && !tasks[index].isCompleted {
            if sampleAppSettings.reminderEnabled, tasks[index].deadline != nil {
                notificationService.scheduleNotifications(for: tasks[index])
            }
        }
    }
    
    /// Sorts tasks based on completion status, deadlines, and titles
    private func sortTasks() {
        DispatchQueue.main.async {
            self.tasks.sort {
                // 1. Incomplete tasks appear first
                if $0.isCompleted != $1.isCompleted {
                    return !$0.isCompleted
                }
                
                // 2. Overdue tasks appear above upcoming tasks
                if let deadline0 = $0.deadline, let deadline1 = $1.deadline {
                    if deadline0 < Date() && deadline1 >= Date() {
                        return true
                    } else if deadline1 < Date() && deadline0 >= Date() {
                        return false
                    }
                }
                
                // 3. Sort by deadline
                if let d0 = $0.deadline, let d1 = $1.deadline {
                    return d0 < d1
                }
                if $0.deadline != nil && $1.deadline == nil {
                    return true
                }
                if $0.deadline == nil && $1.deadline != nil {
                    return false
                }
                
                // 5. Sort by description
                if let desc0 = $0.description, let desc1 = $1.description {
                    return desc0 < desc1
                }
                if $0.description != nil && $1.description == nil {
                    return true
                }
                if $0.description == nil && $1.description != nil {
                    return false
                }
                
                // 6. Alphabetical sorting by title
                if $0.title != $1.title {
                    return $0.title < $1.title
                }
                return false
            }
        }
    }
}
