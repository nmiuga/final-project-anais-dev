// TaskListView.swift
// Main task list screen for the app. Groups tasks by category and allows easy interaction.

import SwiftUI

struct TaskListView: View {
    @EnvironmentObject var viewModel: TaskViewModel
    @StateObject var petViewModel = PetViewModel()
    @State private var showAddTask = false
    @State private var editingTask: Task? = nil
    @State private var showManageCategories = false
    
    // MARK: - Small helpers to keep SwiftUI expressions simple
    private func categoryHeader(_ category: TaskCategory) -> some View {
        Text(category.name)
            .font(.headline)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color.themeBlue.opacity(0.8))
                    .overlay(Capsule().stroke(Color.white.opacity(0.4), lineWidth: 1))
            )
            .foregroundStyle(.white)
    }

    private func priorityBadge(for task: Task) -> some View {
        let baseColor = color(for: task.priority)
        return Text(task.priority.rawValue)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                LinearGradient(
                    colors: [baseColor.opacity(0.85), baseColor.opacity(0.55)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .clipShape(Capsule())
            )
            .overlay(
                Capsule().stroke(Color.white.opacity(0.35), lineWidth: 1)
            )
            .foregroundStyle(.white)
    }

    private func taskRow(_ task: Task) -> some View {
        HStack {
            Button(action: {
                let wasCompleted = task.isCompleted
                viewModel.toggleTaskCompleted(task)
                if !wasCompleted {
                    petViewModel.feed(for: task.priority)
                }
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(task.isCompleted ? Color.themeGreen : Color.themeBlue.opacity(0.7))
                    .shadow(color: task.isCompleted ? Color.themeGreen.opacity(0.35) : .clear, radius: task.isCompleted ? 6 : 0, x: 0, y: 0)
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
            priorityBadge(for: task)
            Button(action: { editingTask = task }) {
                Image(systemName: "pencil")
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white.opacity(0.75))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.black.opacity(0.05), lineWidth: 1)
                )
        )
        .listRowBackground(Color.clear)
        .swipeActions {
            Button(role: .destructive) {
                viewModel.deleteTask(task)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Your Pet")) {
                    PetView(petViewModel: petViewModel)
                }
                if viewModel.tasks.isEmpty {
                    Section {
                        VStack(spacing: 8) {
                            Text("No tasks yet…")
                                .font(.headline)
                            Text("Tap the + button to add your first task.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 12)
                    }
                }
                ForEach(viewModel.groupedTasks, id: \.0.id) { category, tasks in
                    Section(header: categoryHeader(category)) {
                        ForEach(tasks) { task in
                            taskRow(task)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .background(Color.themeBlue.opacity(0.12))
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { showManageCategories = true }) {
                        Label("Categories", systemImage: "folder")
                    }
                    .tint(.themeBlue)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showAddTask = true }) {
                        Label("Add Task", systemImage: "plus")
                    }
                    .tint(.themeYellow)
                }
            }
            .tint(.themeGreen)
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
        case .high: return .themeYellow
        case .medium: return .themeGreen
        case .low: return .themeBlue
        }
    }
}

// This is the main list view for the app. It groups tasks by category, shows priority, and allows completion, deletion, and editing.

