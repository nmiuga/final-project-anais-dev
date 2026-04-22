// TaskViewModel.swift
// ViewModel for the Task Manager app. Manages tasks, categories, and persistence.

import Foundation
import Combine
import SwiftUI

/// The main ViewModel for managing tasks and categories.
class TaskViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var tasks: [Task] = []
    @Published var categories: [TaskCategory] = TaskCategory.default
    
    // For category creation UI
    @Published var newCategoryName: String = ""
    
    // MARK: - Persistence Keys
    private let tasksKey = "tasks_key"
    private let categoriesKey = "categories_key"
    
    init() {
        loadCategories()
        loadTasks()
    }
    
    // MARK: - Task Operations
    func addTask(title: String, description: String, category: TaskCategory, priority: TaskPriority) {
        let task = Task(title: title, category: category, priority: priority, description: description)
        tasks.append(task)
        saveTasks()
    }
    
    /// Edits an existing task identified by id, updating all modifiable fields.
    /// - Parameters:
    ///   - id: The UUID of the task to edit.
    ///   - title: The new title for the task.
    ///   - description: The new description for the task.
    ///   - category: The new category for the task.
    ///   - priority: The new priority for the task.
    ///   - isCompleted: The new completion status for the task.
    func editTask(id: UUID, title: String, description: String, category: TaskCategory, priority: TaskPriority, isCompleted: Bool) {
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            tasks[index].title = title
            tasks[index].description = description
            tasks[index].category = category
            tasks[index].priority = priority
            tasks[index].isCompleted = isCompleted
            saveTasks()
        }
    }
    
    func deleteTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
        saveTasks()
    }
    
    func toggleTaskCompleted(_ task: Task) {
        if let idx = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[idx].isCompleted.toggle()
            saveTasks()
        }
    }
    
    // MARK: - Category Operations
    func addCategory(name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !categories.map { $0.name.lowercased() }.contains(trimmed.lowercased()) else { return }
        let newCat = TaskCategory(id: UUID(), name: trimmed)
        categories.append(newCat)
        saveCategories()
    }
    
    /// Deletes a category. Reassigns any tasks in that category to another remaining category.
    /// - Returns: `true` if the category was deleted; `false` if deletion wasn't possible (e.g., it's the last category).
    @discardableResult
    func deleteCategory(_ category: TaskCategory) -> Bool {
        // Must keep at least one category
        guard categories.count > 1 else { return false }
        guard let removeIndex = categories.firstIndex(of: category) else { return false }
        // Choose a fallback category different from the one being deleted
        guard let fallback = categories.first(where: { $0 != category }) else { return false }
        // Reassign tasks to the fallback category
        for i in tasks.indices {
            if tasks[i].category == category {
                tasks[i].category = fallback
            }
        }
        // Remove the category and persist changes
        categories.remove(at: removeIndex)
        saveTasks()
        saveCategories()
        return true
    }
    
    // MARK: - Sorting & Grouping
    /// Returns tasks grouped by category, with tasks sorted by priority (high to low).
    var groupedTasks: [(TaskCategory, [Task])] {
        let grouped = Dictionary(grouping: tasks) { $0.category }
        // Ensure categories in order of `categories` array
        return categories.compactMap { cat in
            if let group = grouped[cat] {
                return (cat, group.sorted { $0.priority.sortOrder < $1.priority.sortOrder })
            } else {
                return nil
            }
        }
    }
    
    /// Returns all tasks sorted by priority (high to low).
    var allTasksSortedByPriority: [Task] {
        tasks.sorted { $0.priority.sortOrder < $1.priority.sortOrder }
    }
    
    // MARK: - Persistence
    private func saveTasks() {
        if let data = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(data, forKey: tasksKey)
        }
    }
    private func loadTasks() {
        guard let data = UserDefaults.standard.data(forKey: tasksKey),
              let saved = try? JSONDecoder().decode([Task].self, from: data) else { return }
        self.tasks = saved
    }
    private func saveCategories() {
        if let data = try? JSONEncoder().encode(categories) {
            UserDefaults.standard.set(data, forKey: categoriesKey)
        }
    }
    private func loadCategories() {
        if let data = UserDefaults.standard.data(forKey: categoriesKey),
           let saved = try? JSONDecoder().decode([TaskCategory].self, from: data) {
            self.categories = saved
        } else {
            self.categories = TaskCategory.default
        }
    }
}

// MARK: - TaskPriority sorting extension
extension TaskPriority {
    var sortOrder: Int {
        switch self {
        case .high: return 0
        case .medium: return 1
        case .low: return 2
        }
    }
}

// This ViewModel manages all business logic, updates, and persistence for the app.

