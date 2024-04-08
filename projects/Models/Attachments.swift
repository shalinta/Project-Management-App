//
//  Attachments.swift
//  projects
//
//  Created by chirayu-pt6280 on 11/03/23.
//

import Foundation


struct Attachment {
    
    let id:UUID
    let associatedId:UUID
    let name:String
    let path:URL
    let type:AttachmentType
    
    init(id: UUID, itemId: UUID, name: String, path: URL,type:AttachmentType) {
        
        self.id = id
        self.associatedId = itemId
        self.name = name
        self.path = path
        self.type = type
        
    }
    
    init(itemId: UUID, name: String, path: URL,type:AttachmentType) {
        
        self.id = UUID()
        self.associatedId = itemId
        self.name = name
        self.path = path
        self.type = type
        
    }
}
