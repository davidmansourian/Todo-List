//
//  iOSTodoListThesisApp.swift
//  iOSTodoListThesis
//
//  Created by David Mansourian on 2024-02-29.
//

import SwiftData
import SwiftUI

@main
struct iOSTodoListThesisApp: App {
    let container: ModelContainer
    
    @State private var manager: TodoTaskManager
    
    init() {
        do {
            container = try ModelContainer(for: TodoTask.self)
            self._manager = State(wrappedValue: TodoTaskManager(modelContext: container.mainContext))
        } catch {
            fatalError("Couldn't create container for TodoTask")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                TaskListView(manager: manager)
            }
        }
        .modelContainer(container)
    }
}
