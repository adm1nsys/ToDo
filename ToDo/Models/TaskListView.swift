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

//#Preview {
//    TaskListView()
//}
