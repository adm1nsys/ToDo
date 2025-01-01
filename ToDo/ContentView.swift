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
    @State private var tasks: [Task] = [] {
        didSet {
            saveTasks()
        }
    }
    @State private var newTaskTitle: String = ""

    var body: some View {
        ZStack {
            Background().edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack(spacing: 0.0) {
                HeaderView(showSettings: $showSettings, helloHeight: .constant(60))
                TaskEditorView(
                    tasks: $tasks,
                    showEdit: $showEdit,
                    newTaskTitle: $newTaskTitle,
                    saveTasks: saveTasks
                )
                TaskListView(
                    tasks: $tasks,
                    showEdit: $showEdit,
                    deleteTask: deleteTask,
                    toggleTaskCompletion: toggleTaskCompletion
                )

            }
            .onAppear(perform: loadTasks)

            
            if showSettings {
                SettingsView(showSettings: $showSettings)
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showSettings)
        .onAppear {
            loadTasks()
            requestNotificationPermissions()
        }

    }

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

    private func loadTasks() {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: "tasks") {
            do {
                let decoded = try decoder.decode([Task].self, from: data)
                tasks = decoded
                print("Tasks loaded: \(tasks)")
            } catch {
                print("Loading error: \(error)")
            }
        } else {
            print("There are no saved tasks")
        }
    }
    
    private func toggleTaskCompletion(task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            saveTasks()
        }
    }

    private func deleteTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
    }
    
    private func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notification permissions: \(error)")
            } else {
                print("Notification permissions granted: \(granted)")
            }
        }
    }
    
}


#Preview {
    ContentView()
}
