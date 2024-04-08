//
//  DataBaseConstants.swift
//  projects
//
//  Created by chirayu-pt6280 on 15/03/23.
//

import Foundation


struct ProjectTable {
    
    static let title = "PROJECTS"
    
    static let name = "Name"
    static let id = "Id"
    static let startDate = "StartDate"
    static let endDate = "EndDate"
    static let description = "Descpription"
    static let status = "Status"
}


struct TaskTable {
    
    static let title = "TASKS"
    
    static let name = "Name"
    static let id = "Id"
    static let startDate = "StartDate"
    static let endDate = "EndDate"
    static let priority = "Priority"
    static let description = "Description"
    static let isCompleted = "IsCompleted"
    static let projectId = "ProjectId"
    static let projectName = "ProjectName"
    
}


struct ToDoTable {
    
    static let title = "To_DO_LIST"
    static let id = "Id"
    static let task = "Task"
    static let taskId = "TaskId"
    static let isComplete = "IsCompleted"
    
}


struct AttachmentTable {
    
    static let projectAttachmentTable = "PROJECT_ATTACHMENT"
    static let taskAttachmentsTable = "TASK_ATTACHMENT"
    
    static let id = "Id"
    static let name = "Name"
    static let path = "Path"
    static let associatedId = "AssociatedId"
    static let type = "Type"
    
}




