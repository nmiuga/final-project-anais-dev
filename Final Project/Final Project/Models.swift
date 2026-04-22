// Models.swift
// Defines the core models for the Task Manager app.

import Foundation

/// Priority levels for tasks.
enum TaskPriority: String, Codable, CaseIterable, Identifiable {
    case high = "High"
    case medium = "Medium"
    case low = "Low"
    
    var id: String { rawValue }
}

/// Model representing a category for tasks.
struct TaskCategory: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    
    // Default categories
    static let `default`: [TaskCategory] = [
        TaskCategory(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, name: "School"),
        TaskCategory(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, name: "Personal")
    ]
}

/// The main Task model, including title, category, priority, completion status, and description.
struct Task: Identifiable, Codable {
    let id: UUID
    var title: String
    var category: TaskCategory
    var priority: TaskPriority
    var isCompleted: Bool
    var description: String
    
    init(id: UUID = UUID(), title: String, category: TaskCategory, priority: TaskPriority, isCompleted: Bool = false, description: String = "") {
        self.id = id
        self.title = title
        self.category = category
        self.priority = priority
        self.isCompleted = isCompleted
        self.description = description
    }
}

// This file contains all the basic data models needed for the app.
// Next: ViewModel and persistence logic.

