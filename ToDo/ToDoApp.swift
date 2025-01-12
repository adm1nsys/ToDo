//
//  ToDoApp.swift
//  ToDo
//
//  Created by Admin Pro on 12/30/24.
//

import SwiftUI

@main
struct ToDoApp: App {
    // Application-wide settings for managing user preferences
    @StateObject private var appSettings = AppSettings()
    
    // A list to store all tasks managed by the app
    @State private var tasks: [Task] = []
    
    // Service to manage notifications for tasks
    @StateObject private var notificationService: NotificationService

    init() {
        // Initialize the app with an empty task list and a notification service
        let initialTasks: [Task] = []
        
        // Fetch the user's preference for reminders from UserDefaults
        let reminderEnabled = UserDefaults.standard.bool(forKey: "reminderEnabled")
        
        // Initialize the NotificationService with tasks and reminder settings
        _notificationService = StateObject(wrappedValue: NotificationService(tasks: initialTasks,
                                                                             reminderEnabled: reminderEnabled))
    }

    var body: some Scene {
        WindowGroup {
            ContentView(notificationService: notificationService) // Main view of the app
                .environmentObject(appSettings) // Provide app settings to all child views
                .onAppear {
                    loadTasks() // Load saved tasks when the app launches
                }
        }
    }
    
    /// Loads tasks from persistent storage (UserDefaults).
    /// If tasks exist, they are decoded and updated in the app. Otherwise, the task list remains empty.
    private func loadTasks() {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: "tasks") {
            do {
                // Decode tasks from JSON data and update the task list
                let decoded = try decoder.decode([Task].self, from: data)
                tasks = decoded
                
                // Ensure the NotificationService is aware of the latest tasks
                notificationService.updateTasks(tasks)
            } catch {
                // Handle any errors during decoding
                print("Loading error: \(error)")
            }
        }
    }
}
