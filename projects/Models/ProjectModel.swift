//
//  ProjectModel.swift
//  projects
//
//  Created by chirayu-pt6280 on 06/02/23.
//

import Foundation


struct Project {
    
    let id:UUID
    var name:String
    var startDate:Date
    var endDate:Date
    var description:String
    var status:ProjectStatus
    
    
    init(projectId: UUID, projectName: String, startDate: Date, endDate: Date, description: String, status: ProjectStatus) {
        
        self.id = projectId
        self.name = projectName
        self.startDate = startDate
        self.endDate = endDate
        self.description = description
        self.status = status
    }
    
    
    init(projectName:String,startDate:Date,endDate:Date,description:String,status:ProjectStatus) {
        
        self.id = UUID()
        self.name = projectName
        self.startDate = startDate
        self.endDate = endDate
        self.description = description
        self.status = status
        
    }
}
