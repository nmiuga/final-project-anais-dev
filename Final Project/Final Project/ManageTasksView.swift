import SwiftUI

struct ManageTasksView: View {
    @EnvironmentObject var viewModel: TaskViewModel
    @State private var showManageCategories = false
    @State private var showAddTask = false
    @State private var editingTask: Task?

    private var grouped: [(TaskCategory, [Task])] {
        viewModel.groupedTasks
    }

    private var sortedCategories: [TaskCategory] {
        let categories = grouped.map { pair in pair.0 }
        return categories.sorted { lhs, rhs in
            lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
        }
    }

    private func tasksFor(category: TaskCategory) -> [Task] {
        let pair = grouped.first { $0.0 == category }
        return pair?.1 ?? []
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(sortedCategories, id: \.self) { category in
                    Section(header:
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
                    ) {
                        let categoryTasks: [Task] = tasksFor(category: category)
                        ForEach(categoryTasks) { task in
                            TaskRowView(
                                task: task,
                                toggle: { viewModel.toggleTaskCompleted(task) },
                                edit: { editingTask = task },
                                delete: { viewModel.deleteTask(task) }
                            )
                        }
                    }
                }
            }
            .background(Color.themeBlue.opacity(0.12))
            .navigationTitle("Manage Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showManageCategories = true
                    } label: {
                        Label("Categories", systemImage: "folder")
                    }
                    .tint(.themeBlue)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddTask = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .tint(.themeYellow)
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
}

struct TaskRowView: View {
    let task: Task
    let toggle: () -> Void
    let edit: () -> Void
    let delete: () -> Void

    var body: some View {
        HStack {
            Button(action: toggle) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(task.isCompleted ? Color.themeGreen : Color.themeBlue.opacity(0.7))
                    .shadow(color: task.isCompleted ? Color.themeGreen.opacity(0.35) : Color.clear, radius: task.isCompleted ? 6 : 0, x: 0, y: 0)
            }
            VStack(alignment: .leading) {
                Text(task.title)
                    .font(.headline)
                    .strikethrough(task.isCompleted)
                if !task.description.isEmpty {
                    Text(task.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            Text(task.priority.rawValue.capitalized)
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    LinearGradient(
                        colors: [priorityColor(task.priority).opacity(0.85), priorityColor(task.priority).opacity(0.55)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .clipShape(Capsule())
                )
                .overlay(
                    Capsule().stroke(Color.white.opacity(0.35), lineWidth: 1)
                )
                .foregroundStyle(.white)
            Button(action: edit) {
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
        .swipeActions {
            Button(role: .destructive, action: delete) {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

fileprivate func priorityColor(_ priority: TaskPriority) -> Color {
    switch priority {
    case .low:
        return .themeBlue
    case .medium:
        return .themeGreen
    case .high:
        return .themeYellow
    }
}

// Tasks added here are persisted and shared across all views using TaskViewModel's UserDefaults storage

struct ManageTasksView_Previews: PreviewProvider {
    static var previews: some View {
        ManageTasksView()
    }
}
