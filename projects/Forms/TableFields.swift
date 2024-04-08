//
//  Forms.swift
//  projects
//
//  Created by chirayu-pt6280 on 03/03/23.
//

import Foundation
import UIKit

enum TableFieldType {
   
    case textField
    
    case textView
    
    case datePicker
    
    case picker
    
    case button
    
    
}


struct TableViewSection {
    
    let title:String
    let fields:[TableViewField]
    
}


struct TableViewField {
    
    let title:String
    let image:UIImage?
    let type:TableFieldType
    
    init(title: String, image: UIImage?, type: TableFieldType) {
        
        self.title = title
        self.image = image
        self.type = type
        
    }
    
    init(title: String, type: TableFieldType) {
        
        self.title = title
        self.image = nil
        self.type = type
        
    }
    
    init(type:TableFieldType) {
        
        self.title = ""
        self.image = nil
        self.type = type
        
    }
}

