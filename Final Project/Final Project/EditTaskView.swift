// EditTaskView.swift
// Sheet for editing an existing task.

import SwiftUI

struct EditTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: TaskViewModel
    let task: Task

    @State private var title: String
    @State private var description: String
    @State private var selectedCategory: TaskCategory
    @State private var selectedPriority: TaskPriority
    @State private var isCompleted: Bool
    @FocusState private var focusCategoryField: Bool

    init(viewModel: TaskViewModel, task: Task) {
        self.viewModel = viewModel
        self.task = task
        _title = State(initialValue: task.title)
        _description = State(initialValue: task.description)
        _selectedCategory = State(initialValue: task.category)
        _selectedPriority = State(initialValue: task.priority)
        _isCompleted = State(initialValue: task.isCompleted)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Task Title")) {
                    TextField("Title", text: $title)
                        .submitLabel(.done)
                }
                Section(header: Text("Description")) {
                    TextEditor(text: $description)
                        .frame(minHeight: 60)
                }
                Section(header: Text("Category")) {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(viewModel.categories) { category in
                            Text(category.name).tag(category)
                        }
                    }
                    .pickerStyle(.menu)
                }
                Section(header: Text("Priority")) {
                    Picker("Priority", selection: $selectedPriority) {
                        ForEach(TaskPriority.allCases) { priority in
                            Text(priority.rawValue).tag(priority)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Section {
                    Toggle("Completed", isOn: $isCompleted)
                }
            }
            .background(Color.themeBlue.opacity(0.12))
            .tint(.themeGreen)
            .navigationTitle("Edit Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.editTask(
                            id: task.id,
                            title: title,
                            description: description,
                            category: selectedCategory,
                            priority: selectedPriority,
                            isCompleted: isCompleted, dueDate: task.dueDate
                        )
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

// This sheet allows editing all properties of a task, using the ViewModel for saving.

