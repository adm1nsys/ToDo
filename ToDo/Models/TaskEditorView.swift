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
                HStack {
                    TextField("New Task", text: $newTaskTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Add") {
                        if !newTaskTitle.isEmpty {
                            withAnimation {
                                tasks.append(Task(title: newTaskTitle, isCompleted: false))
                            }
                            newTaskTitle = ""
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
}


//#Preview {
//    TaskEditorView()
//}
