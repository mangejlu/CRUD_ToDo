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
    @State private var pendingDeletion: Set<Task> = []

    var body: some View {
        NavigationStack {
            List {
                ForEach(tasks) { task in
                    HStack {
                        Button {
                            task.completed.toggle()
                            try? context.save()

                            if task.completed {
                                pendingDeletion.insert(task)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                    if pendingDeletion.contains(task) {
                                        context.delete(task)
                                        try? context.save()
                                        pendingDeletion.remove(task)
                                    }
                                }
                            }
                        } label: {
                            Image(systemName: task.completed ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(task.completed ? .green : .gray)
                        }

                        Image(systemName: task.category.iconName)
                            .foregroundColor(.accentColor)

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
            }
            .navigationTitle("To-Do List")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $isShowingItemSheet) {
                AddTaskSheet()
            }
            .toolbar {
                Button("Add", systemImage: "plus") {
                    isShowingItemSheet = true
                }
            }
        }
        .padding()
    }
}



#Preview {
    ContentView()
        .modelContainer(for: [Task.self], inMemory: true)
}
