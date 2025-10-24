//
//  TaskDetailsView.swift
//  CRUD
//
//  Created by Alumno on 24/10/25.
//

import SwiftUI
import SwiftData

struct TaskDetailsView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss

    @Bindable var task: Task
    @State private var originalCompletedState: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(categoryColor.opacity(0.2))
                    .frame(width: 80, height: 80)
                
                Image(systemName: task.category.iconName)
                    .font(.system(size: 30, weight: .medium))
                    .foregroundColor(categoryColor)
            }
            .padding(.top, 20)
            
            Form {
                TextField("Task Name", text: $task.name)
                DatePicker("Date", selection: $task.dateAdded, displayedComponents: .date)
                Picker("Category", selection: $task.category) {
                    ForEach(TaskCategory.allCases, id: \.self) { category in
                        Label(category.displayName, systemImage: category.iconName)
                            .tag(category)
                    }
                }
                TextField("Description", text: $task.notes, axis: .vertical)
                    .lineLimit(3...6)
            }
        }
        .navigationTitle("Edit Task")
        .navigationBarTitleDisplayMode(.inline)
        
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    guard Task.isValidName(task.name) else { return }
                    try? context.save()
                    dismiss()
                }
                .disabled(!Task.isValidName(task.name))
            }
        }
    }
    
    private var categoryColor: Color {
        switch task.category {
        case .work:
            return .blue
        case .personal:
            return .purple
        case .shopping:
            return .orange
        case .health:
            return .red
        }
    }
}
