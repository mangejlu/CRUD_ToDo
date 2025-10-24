import SwiftUI
import SwiftData

struct AddTaskSheet: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context

    @State private var name: String = ""
    @State private var dateAdded: Date = .now
    @State private var completed: Bool = false
    @State private var selectedCategory: TaskCategory = .personal
    @State private var description: String = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Task Name", text: $name)
                DatePicker("Date", selection: $dateAdded, displayedComponents: .date)
                Picker("Category", selection: $selectedCategory) {
                    ForEach(TaskCategory.allCases, id: \.self) { category in
                        Label(category.displayName, systemImage: category.iconName)
                            .tag(category)
                    }
                }
                TextField("Description", text: $description, axis: .vertical)
                    .lineLimit(3...6)
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        guard Task.isValidName(name) else { return }
                        
                        let task = Task(
                            name: name,
                            dateAdded: dateAdded,
                            category: selectedCategory,
                            description: description
                        )
                        context.insert(task)
                        try? context.save()
                        dismiss()
                    }
                    .disabled(!Task.isValidName(name))
                }
            }
        }
    }
}

#Preview {
    AddTaskSheet()
}
