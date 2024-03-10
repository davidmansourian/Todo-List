//
//  TodoTaskManager.swift
//  iOSTodoListThesis
//
//  Created by David Mansourian on 2024-02-29.
//

import Foundation
import SwiftData

@Observable
final class TodoTaskManager {
    private var modelContext: ModelContext
    private var daysUntilDeletion = 1
    
    private(set) var tasks: [TodoTask] = []
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchTodoData()
    }
    
    public func addTodoTask(name: String) {
        let task = TodoTask(name: name, isCompleted: false, timestamp: Date.now)
        modelContext.insert(task)
        fetchTodoData()
    }
    
    public func deleteTodoTask(_ todoTask: TodoTask) {
        modelContext.delete(todoTask)
        fetchTodoData()
    }
    
    public func toggleCompletion(_ todoTask: TodoTask) {
        todoTask.isCompleted.toggle()
        
        setCompletion(todoTask)
        
        fetchTodoData()
    }
    
    public func clearCompletedTodoTasks() {
        for task in tasks {
            if let completedDate = task.completedOn,
               let dayDifference = Calendar.current.dateComponents([.day], from: completedDate, to: .now).day {
                dayDifference >= daysUntilDeletion ? deleteTodoTask(task) : nil
            }
        }
        
        fetchTodoData()
    }
    
    private func fetchTodoData() {
        do {
            let descriptor = FetchDescriptor<TodoTask>(sortBy: [SortDescriptor(\.isCompleted, order: .forward), SortDescriptor(\.timestamp)])
            self.tasks = try modelContext.fetch(descriptor)
        } catch {
            print("Fetching from modelContext failed")
        }
    }
    
    private func setCompletion(_ todoTask: TodoTask) {
        todoTask.completedOn = (todoTask.isCompleted ? Date.now : nil)
    }
}

// Need this for isCompleted in sort descriptor
extension Bool: Comparable {
    public static func <(lhs: Self, rhs: Self) -> Bool {
        // the only true inequality is false < true
        !lhs && rhs
    }
}
