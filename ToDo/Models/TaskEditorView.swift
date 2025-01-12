//
//  TaskEditorView.swift
//  ToDo
//
//  Created by Admin Pro on 12/31/24.
//

import SwiftUI

struct TaskEditorView: View {
    // Binds the array of tasks
    @Binding var tasks: [Task]
    // Binds the visibility state of the edit mode
    @Binding var showEdit: Bool
    // Binds the title of the new task
    @Binding var newTaskTitle: String

    var saveTasks: () -> Void
    var sortTasks: () -> Void

    // Access to global settings (e.g., reminderEnabled)
    @EnvironmentObject var appSettings: AppSettings

    // ObservedObject is used here because NotificationService is created externally
    @ObservedObject var notificationService: NotificationService

    @State private var newTaskDescription: String = ""
    @State private var newTaskDeadline: Date = Date()
    @State private var includeDeadline: Bool = true

    var body: some View {
        VStack {
            HStack {
                Text("All TODO")
                    .font(.headline)
                Spacer()
                Button {
                    withAnimation {
                        showEdit.toggle()
                    }
                } label: {
                    Label("Edit", systemImage: "pencil")
                }
                .font(.headline)
                .foregroundColor(showEdit ? .pink : .blue)
            }
            .font(.system(size: 16, weight: .medium, design: .default))
            .padding([.top, .leading, .trailing])

            // If Edit is toggled
            if showEdit {
                VStack(alignment: .leading, spacing: 8) {

                    // Field for task title
                    HStack {
                        Image(systemName: "text.cursor")
                        TextField("Task Title", text: $newTaskTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    // Field for task description
                    HStack {
                        Image(systemName: "text.cursor")
                        TextField("Description (optional)", text: $newTaskDescription)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    // Section for deadline
                    VStack(alignment: .leading, spacing: 8) {
                        Toggle(
                            isOn: Binding(
                                get: { includeDeadline },
                                set: { value in
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        includeDeadline = value
                                    }
                                }
                            ),
                            label: {
                                Label("Add Deadline", systemImage: "clock")
                                    .font(.headline)
                            }
                        )

                        if includeDeadline {
                            DatePicker(
                                "",
                                selection: $newTaskDeadline,
                                displayedComponents: [.date, .hourAndMinute]
                            )
                            .labelsHidden()
                            .datePickerStyle(CompactDatePickerStyle())
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                    .animation(.easeInOut(duration: 0.3), value: includeDeadline)

                    // Add Task button
                    GeometryReader { geometry in
                        Button {
                            if !newTaskTitle.isEmpty {
                                print("Adding a task with the title: \(newTaskTitle)")
                                let newTask = Task(
                                    title: newTaskTitle,
                                    description: newTaskDescription.isEmpty ? nil : newTaskDescription,
                                    deadline: includeDeadline ? newTaskDeadline : nil,
                                    isCompleted: false
                                )

                                // Add to the task array
                                withAnimation {
                                    tasks.append(newTask)
                                    print("Current tasks after adding: \(tasks)")
                                }

                                // Save tasks to UserDefaults
                                saveTasks()

                                // Schedule notifications if the task has a deadline and reminders are enabled
                                if includeDeadline, appSettings.reminderEnabled {
                                    notificationService.scheduleNotifications(for: newTask)
                                }

                                // Sort tasks if needed
                                sortTasks()

                                // Reset all input fields
                                newTaskTitle = ""
                                newTaskDescription = ""
                                includeDeadline = false
                                newTaskDeadline = Date()
                                print("The task is added, all fields are reset.")
                            }
                        } label: {
                            Label("Add Task", systemImage: "plus.circle")
                                .frame(width: geometry.size.width)
                                .padding(.vertical, 15)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        }
                    }
                    .frame(height: 50)
                }
                .padding(.horizontal)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .padding(.bottom, 10.0)
        .onAppear {
            // Disable deadline by default after the view appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                includeDeadline = false
            }
        }

        // Divider
        RoundedRectangle(cornerRadius: 20)
            .fill(Color("BG Accent"))
            .frame(height: 3)
            .padding(.horizontal, 10.0)
            .padding(.bottom, 5.0)
    }

    // Additional initializer for previews if needed
    init(
        tasks: Binding<[Task]>,
        showEdit: Binding<Bool>,
        newTaskTitle: Binding<String>,
        saveTasks: @escaping () -> Void,
        sortTasks: @escaping () -> Void,
        notificationService: NotificationService
    ) {
        self._tasks = tasks
        self._showEdit = showEdit
        self._newTaskTitle = newTaskTitle
        self.saveTasks = saveTasks
        self.sortTasks = sortTasks
        self.notificationService = notificationService
    }
}

// MARK: - Preview

struct TaskEditorView_Previews: PreviewProvider {
    static var previews: some View {
        // iPhone 15 Pro Max iOS 17.2
        TaskEditorViewPreviewWrapper()
            .preferredColorScheme(.light)
            .previewDisplayName("TaskEditorView 15 PM Light")
            .previewDevice("iPhone 15 Pro Max")
            .previewLayout(.device)
        
        TaskEditorViewPreviewWrapper()
            .preferredColorScheme(.dark)
            .previewDisplayName("TaskEditorView 15 PM Dark")
            .previewDevice("iPhone 15 Pro Max")
            .previewLayout(.device)
        
        // iPhone SE (1st generation) iOS 15.5
        TaskEditorViewPreviewWrapper()
            .preferredColorScheme(.light)
            .previewDisplayName("TaskEditorView SE 1Gn Light")
            .previewDevice("iPhone SE (1st generation)")
            .previewLayout(.device)
        
        TaskEditorViewPreviewWrapper()
            .preferredColorScheme(.dark)
            .previewDisplayName("TaskEditorView SE 1Gn Dark")
            .previewDevice("iPhone SE (1st generation)")
            .previewLayout(.device)
    }
}

struct TaskEditorViewPreviewWrapper: View {
    @State var showSettings = false
    @StateObject private var sampleAppSettings = AppSettings()
    var body: some View {
        // Example tasks
        let sampleTasks = [
            Task(title: "Sample Task 1", description: "Desc 1", deadline: Date().addingTimeInterval(3600), isCompleted: false),
            Task(title: "Sample Task 2", description: "Desc 2", deadline: Date().addingTimeInterval(7200), isCompleted: true)
        ]
        let sampleNotificationService = NotificationService(tasks: sampleTasks, reminderEnabled: true)
        let sampleAppSettings = AppSettings()

        ZStack{
            Background()
            VStack{
                HeaderView(showSettings: $showSettings, helloHeight: .constant(60))
                    .opacity(0)
                    .scaleEffect(0)
                TaskEditorView(
                    tasks: .constant(sampleTasks),
                    showEdit: .constant(true),
                    newTaskTitle: .constant("New Task"),
                    saveTasks: {},
                    sortTasks: {},
                    notificationService: sampleNotificationService
                )
                .environmentObject(sampleAppSettings)
                Spacer()
            }
        }
        

    }
}
