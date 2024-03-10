//
//  AddTaskView.swift
//  iOSTodoListThesis
//
//  Created by David Mansourian on 2024-02-29.
//

import SwiftData
import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var taskName = ""
    
    let manager: TodoTaskManager
    
    var body: some View {
        Form {
            Section {
                TextField("Task name", text: $taskName)
                    .clearTextFieldButton(text: $taskName, color: .black)
            } header: {
                Text("Task")
            }
            
            Button(action: {
                manager.addTodoTask(name: taskName)
                dismiss()
            }, label: {
                Text("Add")
            })
            .controlSize(.large)
            .buttonStyle(.borderedProminent)
            .listRowBackground(Color.clear)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TodoTask.self, configurations: config)
    
    return AddTaskView(manager: TodoTaskManager(modelContext: container.mainContext))
        .modelContainer(container)
}
