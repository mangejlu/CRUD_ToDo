//
//  AddTaskSheet.swift
//  CRUD
//
//  Created by Alumno on 22/10/25.
//
import SwiftUI
import SwiftData

struct AddTaskSheet: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    @State private var name: String = ""
    @State private var dateAdded: Date = .now
    @State private var completed: Bool = false
    @State private var selectedCategory: TaskCategory = .personal
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Task Name", text: $name)
                DatePicker("Date", selection: $dateAdded, displayedComponents: .date)
                Toggle("Completed", isOn: $completed)
                Picker("Category", selection: $selectedCategory) {
                    ForEach(TaskCategory.allCases, id: \.self) { category in
                        Label(category.displayName, systemImage: category.iconName)
                            .tag(category)
                    }
                }
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Save") {
                        let task = Task(name: name, dateAdded: dateAdded, completed: completed, category: selectedCategory)
                        context.insert(task)
                        try! context.save()
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AddTaskSheet()
}
