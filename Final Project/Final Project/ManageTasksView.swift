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
                    Section(header: Text(category.name)) {
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
            .navigationTitle("Manage Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showManageCategories = true
                    } label: {
                        Label("Categories", systemImage: "folder")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddTask = true
                    } label: {
                        Image(systemName: "plus")
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
                    .foregroundColor(task.isCompleted ? .green : .gray)
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
                .padding(6)
                .background(priorityColor(task.priority))
                .foregroundColor(.white)
                .clipShape(Capsule())
            Button(action: edit) {
                Image(systemName: "pencil")
            }
            .buttonStyle(.plain)
        }
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
        return .blue
    case .medium:
        return .orange
    case .high:
        return .red
    }
}

// Tasks added here are persisted and shared across all views using TaskViewModel's UserDefaults storage

struct ManageTasksView_Previews: PreviewProvider {
    static var previews: some View {
        ManageTasksView()
    }
}
