//
//  ContentView.swift
//  ToDo
//
//  Created by Admin Pro on 12/30/24.
//

import SwiftUI
import CoreData

struct ContentView: View {

    @State var showSettings = false
    @State private var showEdit = false
    @State private var tasks: [Task] = [] {
        didSet {
            saveTasks()
        }
    }
    @State private var newTaskTitle: String = ""
    @State private var helloHeight: CGFloat = 0
    
    var body: some View {
        ZStack{
            Background()
            GeometryReader { geometry in
                VStack{
                    
                    HeaderView(showSettings: $showSettings, helloHeight: $helloHeight)
                        

                    VStack(spacing: 0.0){

                        TaskEditorView(tasks: $tasks, showEdit: $showEdit, newTaskTitle: $newTaskTitle)
                        
                        TaskListView(tasks: $tasks, showEdit: $showEdit)
                    
                    
                    }
                    .background(BG2()).padding(.horizontal)
                    
                    
                        
                        GitLink()
                    
                    
                }
            }
            
            ZStack {
                if showSettings {
                    SettingsView(showSettings: $showSettings)
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: showSettings)

            
        }.onAppear(perform: loadTasks)
    }

    
        private func saveTasks() {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(tasks) {
                UserDefaults.standard.set(encoded, forKey: "tasks")
            }
        }

    
        private func loadTasks() {
            let decoder = JSONDecoder()
            if let data = UserDefaults.standard.data(forKey: "tasks"),
               let decodedTasks = try? decoder.decode([Task].self, from: data) {
                tasks = decodedTasks
            }
        }
    private func deleteTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
    }

}


#Preview {
    ContentView()
}
