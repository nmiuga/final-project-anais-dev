// ManageCategoriesView.swift
// Screen to manage (delete) categories.

import SwiftUI

struct ManageCategoriesView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: TaskViewModel

    @State private var showCannotDeleteAlert = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.categories) { category in
                    HStack {
                        Text(category.name)
                        Spacer()
                        // Count tasks in this category for context
                        let count = viewModel.tasks.filter { $0.category == category }.count
                        if count > 0 {
                            Text("\(count)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("Categories")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .alert("Can't Delete Category", isPresented: $showCannotDeleteAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("You must have at least one category.")
            }
        }
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            let category = viewModel.categories[index]
            let success = viewModel.deleteCategory(category)
            if !success {
                showCannotDeleteAlert = true
            }
        }
    }
}

#Preview {
    ManageCategoriesView(viewModel: TaskViewModel())
}
