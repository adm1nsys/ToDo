//
//  ContentView.swift
//  ToDo
//
//  Created by Admin Pro on 12/30/24.
//

import SwiftUI
import CoreData
import UserNotifications

struct ContentView: View {
    @State var showSettings = false
    @State private var showEdit = false
    
    /// Main array of tasks
    @State private var tasks: [Task] = [] {
        didSet {
            saveTasks()
            // Update the notification service with only incomplete tasks
            notificationService.updateTasks(tasks.filter { !$0.isCompleted })
        }
    }
    
    @State private var newTaskTitle: String = ""
    @State private var newTaskDeadline = Date()
    
    // Flags and UI settings
    @State private var showLoadScreen = true
    @State private var isHidden = false
    
    // Animation timings
    private let fadeDuration = 0.3
    private let moveDuration = 0.3
    private let appearanceDelay = 0.0
    
    @State private var settingsOpacity = 0.0
    @State private var settingsOffset = UIScreen.main.bounds.width
    
    // Global settings object (e.g., for reminders)
    @EnvironmentObject var appSettings: AppSettings
    
    /// Notification service object
    @StateObject private var notificationService: NotificationService

    /// Initializer that accepts a pre-configured notification service
    init(notificationService: NotificationService) {
        _notificationService = StateObject(wrappedValue: notificationService)
    }
    
    // Flag for onboarding
    @State private var showOnboarding = false
    
    @AppStorage("userName") var userName: String = ""

    var body: some View {
        ZStack {
            // Background view
            Background()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0.0) {
                
                // Top panel
                HeaderView(showSettings: $showSettings, helloHeight: .constant(60))
                    .offset(x: isHidden ? -UIScreen.main.bounds.width : 0)
                    .opacity(isHidden ? 0 : 1)
                    .animation(.easeInOut(duration: 0.3), value: isHidden)
                
                // Task editor view
                TaskEditorView(
                    tasks: $tasks,
                    showEdit: $showEdit,
                    newTaskTitle: $newTaskTitle,
                    saveTasks: saveTasks,
                    sortTasks: sortTasks,
                    notificationService: notificationService
                )
                .offset(x: isHidden ? -UIScreen.main.bounds.width : 0)
                .opacity(isHidden ? 0 : 1)
                .animation(.easeInOut(duration: 0.3).delay(0.3), value: isHidden)

                // Task list view
                TaskListView(
                    tasks: $tasks,
                    showEdit: $showEdit,
                    deleteTask: deleteTask,
                    toggleTaskCompletion: { task in
                        toggleTaskCompletion(for: task)
                        sortTasks()
                    }
                )
                .offset(x: isHidden ? -UIScreen.main.bounds.width : 0)
                .opacity(isHidden ? 0 : 1)
                .animation(.easeInOut(duration: 0.3).delay(0.6), value: isHidden)
                
            }
            .onAppear {
                // Actions to perform when ContentView appears
                loadTasks()
                sortTasks()
                requestNotificationPermissions()
                
                // Delay to ensure smooth animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    isHidden = false
                }
                
                // Synchronize notification settings with app settings
                notificationService.reminderEnabled = appSettings.reminderEnabled
                
                // Assign delegate if additional handling is needed
                UNUserNotificationCenter.current().delegate = notificationService
            }
            .onChange(of: appSettings.reminderEnabled) { newValue in
                // Handle changes to the global reminder toggle
                notificationService.reminderEnabled = newValue
                
                // If reminders are enabled, reschedule notifications for active tasks
                if newValue {
                    let activeTasks = tasks.filter { !$0.isCompleted && $0.deadline != nil }
                    for task in activeTasks {
                        notificationService.scheduleNotifications(for: task)
                    }
                }
            }
            
            // Settings view (slides in from the right)
            SettingsView(showSettings: $showSettings)
                .offset(x: settingsOffset)
                .opacity(settingsOpacity)
                .onChange(of: showSettings) { newValue in
                    if newValue {
                        // Show settings
                        settingsOpacity = 1.0
                        settingsOffset = 0
                    } else {
                        // Hide settings
                        withAnimation(.easeInOut(duration: fadeDuration).delay(0.9)) {
                            settingsOpacity = 0.0
                        }
                        // Validate user name
                        let trimmed = userName.trimmingCharacters(in: .whitespacesAndNewlines)
                        if trimmed.isEmpty || trimmed == "User" {
                            withAnimation {
                                showOnboarding = true
                            }
                        }
                    }
                }
            
            // Onboarding view (SetUpView)
            if showOnboarding {
                SetUpView(
                    userName: $userName,
                    reminderEnabled: $appSettings.reminderEnabled
                ) {
                    // Actions to perform when onboarding is completed
                    withAnimation {
                        showOnboarding = false
                    }
                }
                .transition(.opacity)
                .zIndex(1)
            }
            
            // Loading screen
            if showLoadScreen {
                LoadScreenView {
                    showLoadScreen = false
                }
                .transition(.opacity)
                .zIndex(2)
            }
            
        } // ZStack
        .onChange(of: showSettings) { newValue in
            // Hide the main UI when settings are displayed
            withAnimation {
                isHidden = newValue
            }
        }
        .onAppear {
            // Actions to perform when ContentView appears (repeated calls)
            loadTasks()
            UNUserNotificationCenter.current().delegate = notificationService
            requestNotificationPermissions()
            let trimmed = userName.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed.isEmpty || trimmed == "User" {
                withAnimation {
                    showOnboarding = true
                }
            }
        }
    }
}

// MARK: - Methods for ContentView (CRUD operations for tasks)

extension ContentView {
    
    /// Saves tasks to UserDefaults
    private func saveTasks() {
        let encoder = JSONEncoder()
        do {
            let encoded = try encoder.encode(tasks)
            UserDefaults.standard.set(encoded, forKey: "tasks")
            print("Tasks saved:\(tasks)")
        } catch {
            print("Save error: \(error)")
        }
    }
    
    /// Loads tasks from UserDefaults
    private func loadTasks() {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: "tasks") {
            do {
                let decoded = try decoder.decode([Task].self, from: data)
                tasks = decoded
                notificationService.updateTasks(tasks.filter { !$0.isCompleted })
                print("Tasks loaded: \(tasks)")
            } catch {
                print("Loading error: \(error)")
            }
        } else {
            print("There are no saved tasks")
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
            if appSettings.reminderEnabled, tasks[index].deadline != nil {
                notificationService.scheduleNotifications(for: tasks[index])
            }
        }
    }
    
    /// Requests notification permissions from the user
    private func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notification permissions: \(error)")
            } else {
                print("Notification permissions granted: \(granted)")
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
    
    /// Checks if the username is valid
    private func checkForEmptyName() {
        let trimmed = userName.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty || trimmed.lowercased() == "user" {
            showOnboarding = true
        }
    }
}

// MARK: - Preview

#Preview {
    // Sample data for preview
    let sampleTasks = [
        Task(title: "Sample Task 1", description: "Description 1", deadline: Date().addingTimeInterval(3600), isCompleted: false),
        Task(title: "Sample Task 2", description: "Description 2", deadline: Date().addingTimeInterval(7200), isCompleted: true)
    ]
    let sampleNotificationService = NotificationService(tasks: sampleTasks, reminderEnabled: true)
    let sampleAppSettings = AppSettings()

    return ContentView(notificationService: sampleNotificationService)
        .environmentObject(sampleAppSettings)
}
