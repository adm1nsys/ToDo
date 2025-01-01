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

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach($tasks) { $task in
                    HStack {
                        Text(task.title)
                            .strikethrough(task.isCompleted, color: .red)
                            .foregroundColor(task.isCompleted ? .gray : .primary)
                            .animation(.easeInOut(duration: 0.3), value: task.isCompleted)

                        Spacer()

                        if showEdit {
                            Button {
                                withAnimation {
                                    tasks.removeAll { $0.id == task.id }
                                }
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.pink)
                            }
                        }

                        Button {
                            task.isCompleted.toggle()
                        } label: {
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .transition(.opacity.combined(with: .slide))
                }
            }
            .padding(.horizontal, 10)
        }
    }
}

//#Preview {
//    TaskListView()
//}
