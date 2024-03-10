//
//  ContentView.swift
//  iOSTodoListThesis
//
//  Created by David Mansourian on 2024-02-29.
//

import SwiftData
import SwiftUI

struct TaskListView: View {
    @State private var isAddingTodoTask = false
    
    let manager: TodoTaskManager
    
    var body: some View {
        Group {
            if !manager.tasks.isEmpty {
                List {
                    ForEach(manager.tasks, id: \.self) { task in
                        HStack(spacing: 20) {
                            Button(action: {
                                withAnimation {
                                    manager.toggleCompletion(task)
                                }
                            }, label: {
                                Image(systemName: "checkmark")
                                    .symbolVariant(.circle.fill)
                                    .foregroundStyle(task.isCompleted ? .green : .gray)
                                    .font(.title)
                            })
                            
                            Text(task.name)
                                .strikethrough(task.isCompleted, color: .black)
                        }
                    }
                    .onDelete(perform: delete)
                }
                .onAppear {
                    manager.clearCompletedTodoTasks()
                }
            } else {
                ContentUnavailableView("Your todo list is empty",
                                       systemImage: "plus.circle.fill",
                                       description: Text("Your todo list is empty! Tap the '+' on the toolbar to add new tasks."))
            }
        }
        .navigationTitle("Todo list")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {isAddingTodoTask.toggle()}, label: {
                    Image(systemName: "plus")
                })
                .buttonStyle(.plain)
            }
        }
        .sheet(isPresented: $isAddingTodoTask) {
            AddTaskView(manager: manager)
                .presentationDragIndicator(.visible) // Doesn't seem to work when the view utilizes "Form"
        }
    }
}

extension TaskListView {
    func delete(at offsets: IndexSet) {
        let tasks = offsets.compactMap { manager.tasks[$0] }
        
        for task in tasks {
            manager.deleteTodoTask(task)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TodoTask.self, configurations: config)
    
    for i in 1..<10 {
        let date = Date.now
        let task = TodoTask(name: "Example task \(i)", isCompleted: i == 8 ? true : false, timestamp: date)
        container.mainContext.insert(task)
    }
    
    let manager = TodoTaskManager(modelContext: container.mainContext)
    
    return NavigationStack{TaskListView(manager: manager)}
        .modelContainer(container)
}
