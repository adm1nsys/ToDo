//
//  Task.swift
//  ToDo
//
//  Created by Admin Pro on 12/31/24.
//

import Foundation

struct Task: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String?
    var deadline: Date?
    var isCompleted: Bool

    init(id: UUID = UUID(), title: String, description: String? = nil, deadline: Date? = nil, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.description = description
        self.deadline = deadline
        self.isCompleted = isCompleted
    }
}
