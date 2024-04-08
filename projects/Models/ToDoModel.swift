//
//  CheckListModel.swift
//  projects
//
//  Created by chirayu-pt6280 on 10/03/23.
//

import Foundation

struct ToDoItem {
    
    let taskId:UUID
    let Id:UUID
    var toDo:String
    var isComplete:Bool
    
    init(taskId: UUID, Id: UUID, task: String, isComplete: Bool) {
        
        self.taskId = taskId
        self.Id = Id
        self.toDo = task
        self.isComplete = isComplete
    }
    
    init(taskId: UUID, task: String, isComplete: Bool) {
        
        self.taskId = taskId
        self.Id = UUID()
        self.toDo = task
        self.isComplete = isComplete
    }
    
    
}

