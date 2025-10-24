//
//  ToDoModel.swift
//  CRUD
//
//  Created by Alumno on 22/10/25.
//
import Foundation
import SwiftData

enum TaskCategory: String, Codable, CaseIterable {
    case work, personal, shopping, health

    var iconName: String {
        switch self {
        case .work: return "briefcase.fill"
        case .personal: return "person.fill"
        case .shopping: return "cart.fill"
        case .health: return "heart.fill"
        }
    }

    var displayName: String {
        rawValue.capitalized
    }
}

@Model
class Task {
    var name: String
    var dateAdded: Date
    var completed: Bool
    var category: TaskCategory

    init(name: String, dateAdded: Date, completed: Bool, category: TaskCategory) {
        self.name = name
        self.dateAdded = dateAdded
        self.completed = completed
        self.category = category
    }
}
