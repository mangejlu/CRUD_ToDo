//
//  ContentView.swift
//  CRUD
//
//  Created by Alumno on 22/10/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var isShowingItemSheet: Bool = false
    @Query(sort: \Task.dateAdded) var tasks: [Task]
    @Environment(\.modelContext) private var context
    @State private var pendingDeletion: Set<PersistentIdentifier> = []
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(tasks) { task in
                    NavigationLink {
                        TaskDetailsView(task: task)
                    } label: {
                        HStack {
                            Button {
                                task.completed.toggle()
                                try? context.save()
                                
                                if task.completed {
                                    scheduleDeletion(for: task)
                                }
                            } label: {
                                Image(systemName: task.completed ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(task.completed ? .green : .gray)
                            }
                            .buttonStyle(PlainButtonStyle())

                            Image(systemName: task.category.iconName)
                                .font(.system(size: 16))
                                .foregroundColor(categoryColor(for: task.category))
                                .frame(width: 24)

                            VStack(alignment: .leading) {
                                Text(task.name)
                                    .font(.headline)
                                    .strikethrough(task.completed)
                                    .foregroundColor(task.completed ? .gray : .primary)
                                Text(task.category.displayName)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }

                            Spacer()
                        }
                        .padding(.vertical, 4)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            context.delete(task)
                            try? context.save()
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle("To-Do List")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $isShowingItemSheet) {
                AddTaskSheet()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add", systemImage: "plus") {
                        isShowingItemSheet = true
                    }
                }
            }
        }
    }

    private func scheduleDeletion(for task: Task) {
        pendingDeletion.insert(task.id)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            if pendingDeletion.contains(task.id) {
                context.delete(task)
                try? context.save()
                pendingDeletion.remove(task.id)
            }
        }
    }
    
    private func categoryColor(for category: TaskCategory) -> Color {
        switch category {
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

#Preview {
    ContentView()
        .modelContainer(for: [Task.self], inMemory: true)
}
