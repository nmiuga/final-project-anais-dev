// TaskListView.swift
// Main task list screen for the app. Groups tasks by category and allows easy interaction.

import SwiftUI

struct TaskListView: View {
    @StateObject var viewModel = TaskViewModel()
    @State private var showAddTask = false
    @State private var editingTask: Task? = nil
    @State private var showManageCategories = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.groupedTasks, id: \.0.id) { category, tasks in
                    Section(header: Text(category.name).font(.headline)) {
                        ForEach(tasks) { task in
                            HStack {
                                Button(action: { viewModel.toggleTaskCompleted(task) }) {
                                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                        .foregroundStyle(task.isCompleted ? .green : .secondary)
                                }
                                .buttonStyle(.plain)
                                VStack(alignment: .leading) {
                                    Text(task.title)
                                        .strikethrough(task.isCompleted, color: .secondary)
                                        .foregroundStyle(task.isCompleted ? .secondary : .primary)
                                    if !task.description.isEmpty {
                                        Text(task.description)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                Spacer()
                                Text(task.priority.rawValue)
                                    .font(.caption)
                                    .foregroundStyle(color(for: task.priority))
                                Button(action: { editingTask = task }) {
                                    Image(systemName: "pencil")
                                }
                                .buttonStyle(.plain)
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    viewModel.deleteTask(task)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { showManageCategories = true }) {
                        Label("Categories", systemImage: "folder")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showAddTask = true }) {
                        Label("Add Task", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddTask) {
                AddTaskView(viewModel: viewModel)
            }
            .sheet(item: $editingTask) { task in
                EditTaskView(viewModel: viewModel, task: task)
            }
            .sheet(isPresented: $showManageCategories) {
                ManageCategoriesView(viewModel: viewModel)
            }
        }
    }
    
    private func color(for priority: TaskPriority) -> Color {
        switch priority {
        case .high: return .red
        case .medium: return .orange
        case .low: return .gray
        }
    }
}

// This is the main list view for the app. It groups tasks by category, shows priority, and allows completion, deletion, and editing.

