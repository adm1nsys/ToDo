//
//  TaskEditorView.swift
//  ToDo
//
//  Created by Admin Pro on 12/31/24.
//

import SwiftUI

struct TaskEditorView: View {
    @Binding var tasks: [Task]
    @Binding var showEdit: Bool
    @Binding var newTaskTitle: String
    var saveTasks: () -> Void
    
    @State private var newTaskDescription: String = ""
    @State private var newTaskDeadline: Date = Date()
    @State private var includeDeadline: Bool = false

    var body: some View {
        VStack {
            HStack {
                Text("All TODO")
                    .fontWeight(.bold)
                Spacer()
                Button("Edit") {
                    withAnimation {
                        showEdit.toggle()
                    }
                }
                .foregroundColor(showEdit ? .pink : .blue)
            }
            .font(.system(size: 16, weight: .medium, design: .default))
            .padding([.top, .leading, .trailing])

            if showEdit {
                VStack(alignment: .leading, spacing: 8) {
                    TextField("Task Title", text: $newTaskTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Description (optional)", text: $newTaskDescription)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Toggle("Add Deadline", isOn: $includeDeadline)
                    
                    if includeDeadline {
                        DatePicker("Deadline", selection: $newTaskDeadline, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(CompactDatePickerStyle())
                    }

                    HStack {
                        Spacer()
                        Button("Add Task") {
                            if !newTaskTitle.isEmpty {
                                print("Adding a task with the title: \(newTaskTitle)")
                                let newTask = Task(
                                    title: newTaskTitle,
                                    description: newTaskDescription.isEmpty ? nil : newTaskDescription,
                                    deadline: includeDeadline ? newTaskDeadline : nil,
                                    isCompleted: false
                                )
                                withAnimation {
                                    tasks.append(newTask)
                                    print("Current tasks after adding: \(tasks)")
                                }
                                saveTasks()

                                if includeDeadline {
                                    scheduleNotification(for: newTask)
                                }

                                newTaskTitle = ""
                                newTaskDescription = ""
                                includeDeadline = false
                                newTaskDeadline = Date()
                                print("The task is added, all fields are reset.")
                            }
                        }

                    }
                }
                .padding(.horizontal)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .padding(.bottom, 10.0)
        
        RoundedRectangle(cornerRadius: 20)
            .fill(Color("BG Accent"))
            .frame(height: 3)
            .padding(.horizontal, 10.0)
            .padding(.bottom, 5.0)
    }
    
    private func scheduleNotification(for task: Task) {
        guard let deadline = task.deadline else { return }

        let content = UNMutableNotificationContent()
        content.title = "Task Reminder"
        content.body = "Your task \(task.title) is due soon."
        content.sound = .default

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: deadline)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: task.id.uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled successfully for task: \(task.title) at \(deadline)")
            }
        }
    }
    
}

//#Preview {
//    TaskEditorView()
//}
