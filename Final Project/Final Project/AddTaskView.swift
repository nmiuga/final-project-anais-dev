// AddTaskView.swift
// Modal sheet for adding a new task and managing categories.

import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: TaskViewModel
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var selectedCategory: TaskCategory?
    @State private var selectedPriority: TaskPriority = .medium
    @State private var newCategoryName: String = ""
    @State private var hasDueDate: Bool = false
    @State private var dueDate: Date = Date()
    @FocusState private var focusCategoryField: Bool
    
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
                            Text(category.name).tag(Optional(category))
                        }
                    }
                    .pickerStyle(.menu)
                    HStack {
                        TextField("Add new category", text: $newCategoryName)
                            .focused($focusCategoryField)
                        Button("Add") {
                            withAnimation {
                                viewModel.addCategory(name: newCategoryName)
                                newCategoryName = ""
                                focusCategoryField = false
                            }
                        }
                        .disabled(newCategoryName.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }
                Section(header: Text("Priority")) {
                    Picker("Priority", selection: $selectedPriority) {
                        ForEach(TaskPriority.allCases) { priority in
                            Text(priority.rawValue).tag(priority)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Section(header: Text("Due")) {
                    Toggle("Set due date", isOn: $hasDueDate)
                    if hasDueDate {
                        DatePicker("Date & Time", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                    }
                }
            }
            .background(Color.themeBlue.opacity(0.12))
            .tint(.themeGreen)
            .navigationTitle("Add Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let cat = selectedCategory ?? viewModel.categories.first {
                            viewModel.addTask(title: title, description: description, category: cat, priority: selectedPriority, dueDate: hasDueDate ? dueDate : nil)
                            dismiss()
                        }
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear {
                selectedCategory = viewModel.categories.first
            }
            .onDisappear {
                // Reset fields if needed on dismiss - generally the view is discarded after dismiss, so optional.
                title = ""
                description = ""
                selectedPriority = .medium
                newCategoryName = ""
                hasDueDate = false
                dueDate = Date()
                selectedCategory = viewModel.categories.first
            }
        }
    }
}

// This view is presented as a sheet for adding a new task, with controls for category, description, and priority.

