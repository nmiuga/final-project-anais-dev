import SwiftUI

struct ManageTasksView: View {
    @StateObject var viewModel = TaskViewModel()
    @State private var showManageCategories = false
    @State private var showAddTask = false
    @State private var editingTask: Task?

    var body: some View {
        NavigationStack {
            // Precompute sorted categories to help the type-checker
            let categories: [String] = Array(viewModel.groupedTasks.keys).sorted()

            List {
                ForEach(categories, id: \.self) { category in
                    // Bind tasks for this category to a local constant to avoid complex subscripts
                    let tasks: [Task] = viewModel.groupedTasks[category] ?? []

                    Section(header: Text(category)) {
                        ForEach(tasks) { task in
                            HStack {
                                Button(action: {
                                    viewModel.toggleCompletion(task)
                                }) {
                                    Image(systemName: task.isComplete ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(task.isComplete ? .green : .gray)
                                }
                                VStack(alignment: .leading) {
                                    Text(task.title)
                                        .font(.headline)
                                        .strikethrough(task.isComplete)
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
                                Button {
                                    editingTask = task
                                } label: {
                                    Image(systemName: "pencil")
                                }
                                .buttonStyle(BorderlessButtonStyle())
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

    private func priorityColor(_ priority: TaskPriority) -> Color {
        switch priority {
        case .low:
            return .blue
        case .medium:
            return .orange
        case .high:
            return .red
        }
    }
}

// Tasks added here are persisted and shared across all views using TaskViewModel's UserDefaults storage

struct ManageTasksView_Previews: PreviewProvider {
    static var previews: some View {
        ManageTasksView()
    }
}
