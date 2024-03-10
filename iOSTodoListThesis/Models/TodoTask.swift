//
//  Task.swift
//  iOSTodoListThesis
//
//  Created by David Mansourian on 2024-02-29.
//

import Foundation
import SwiftData

@Model
class TodoTask {
    let name: String
    var isCompleted: Bool
    var completedOn: Date?
    let timestamp: Date
    
    init(name: String, isCompleted: Bool, completedOn: Date? = nil, timestamp: Date) {
        self.name = name
        self.isCompleted = isCompleted
        self.completedOn = completedOn
        self.timestamp = timestamp
    }
}
