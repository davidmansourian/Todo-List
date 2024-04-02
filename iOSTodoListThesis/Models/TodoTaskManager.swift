//
//  TodoTaskManager.swift
//  iOSTodoListThesis
//
//  Created by David Mansourian on 2024-02-29.
//

import Foundation
import SwiftData

// Observable usually requires specifying if something should be executed on main thread
// https://forums.swift.org/t/observable-macro-conflicting-with-mainactor/67309
// But everything here seems to be executed on the main thread, maybe becuase SwiftData automatically do stuff on the main thread?
// https://forums.developer.apple.com/forums/thread/736226
// Anyways, I'm sharing this info becuase I am updating stuff in the view without specifying main thread

@Observable
final class TodoTaskManager {
    private var modelContext: ModelContext
    private var daysUntilDeletion = 1
    
    private(set) var tasks: [TodoTask] = []
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchTodoData()
    }
    
    // MARK: Function description
    /// This function creates a TodoTask-object based on the name entered in the view.
    /// the task is then added into the modelContext (databse). The class function fetchTodoData()
    /// is called to update the class variable 'tasks' which is the array used in the view to represent the TodoTasks
    public func addTodoTask(name: String) {
        let task = TodoTask(name: name, isCompleted: false, timestamp: Date.now)
        modelContext.insert(task)
        fetchTodoData()
    }
    
    // MARK: Function description
    /// This function deletes the TodoTask inserted into the function from the modelContext (database)
    /// the function then calls the class function fetchTodoData() to update the class variable 'tasks',
    /// which is the array used in the view to represent the TodoTasks
    public func deleteTodoTask(_ todoTask: TodoTask) {
        modelContext.delete(todoTask)
        fetchTodoData()
    }
    
    // MARK: Function description
    /// This function toggles the completion for the inserted TodoTask.
    /// If isCompleted is now true, then a completedOn-date is set as the date right now,
    /// otherwise the completedOn is set to nil. The class function fetchTodoData() is then called
    /// to update the class variable 'tasks' which is the array used in the view to represent the TodoTasks
    public func toggleCompletion(_ todoTask: TodoTask) {
        todoTask.isCompleted.toggle()
        
        todoTask.completedOn = (todoTask.isCompleted ? Date.now : nil)
        
        fetchTodoData()
    }
    
    // MARK: Function description
    /// - Loop through class variable 'tasks'
    /// - Check if completedOn exists
    /// - If completedOn exists, calculate day difference between "today" and completedOn
    /// - If dayDifference is greater than or equal to class variable 'daysUntilDeletion', call deleteTodoTask(_ todoTask: TodoTask), else do nothing
    /// - update class variable 'tasks' by calling fetchTodoData()
    public func clearCompletedTodoTasks() {
        for task in tasks {
            if let completedDate = task.completedOn,
               let dayDifference = Calendar.current.dateComponents([.day], from: completedDate, to: .now).day {
                dayDifference >= daysUntilDeletion ? deleteTodoTask(task) : nil
            }
        }
        
        fetchTodoData()
    }
    
    // MARK: Function description
    /// - Start do-catch block
    /// - Create a descriptor that fetched 'TodoTask' from the datbase with sorting criteria for completed and timestamp (creation date)
    /// - set class variable 'tasks' to the sorted fetched data from modelContext
    /// - If necessary, enter catch
    /// - Print custom message if error in catch
    private func fetchTodoData() {
        do {
            let descriptor = FetchDescriptor<TodoTask>(sortBy: [SortDescriptor(\.isCompleted, order: .forward), SortDescriptor(\.timestamp)])
            self.tasks = try modelContext.fetch(descriptor)
        } catch {
            print("Fetching from modelContext failed")
        }
    }
}

// Need this for isCompleted in sort descriptor
extension Bool: Comparable {
    public static func <(lhs: Self, rhs: Self) -> Bool {
        // the only true inequality is false < true
        !lhs && rhs
    }
}
