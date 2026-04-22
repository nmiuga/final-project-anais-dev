import SwiftUI

struct CategoryListView: View {
    @State private var categories: [String] = ["Work", "Personal", "Groceries"]
    @State private var showAlert = false

    var body: some View {
        NavigationView {
            List {
                ForEach(categories, id: \.self) { category in
                    Text(category)
                }
                .onDelete(perform: deleteCategory)
            }
            .navigationTitle("Categories")
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Cannot Delete"),
                    message: Text("You must have at least one category."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

    private func deleteCategory(at offsets: IndexSet) {
        guard categories.count > 1 else {
            showAlert = true
            return
        }
        categories.remove(atOffsets: offsets)
    }
}

struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView()
    }
}
