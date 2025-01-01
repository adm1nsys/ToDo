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
    
    var body: some View {
        ScrollView {
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
                                    print("Задача удалена: \(task)")
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
                                    .foregroundColor(.blue)
                                Spacer()
                                if Calendar.current.isDateInToday(deadline) {
                                    Text("Today!")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }

            }
            .padding(.horizontal, 10)
        }
    }

    private var taskDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
}

//#Preview {
//    TaskListView()
//}
