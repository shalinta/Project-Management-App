//
//  Theme.swift
//  projects
//
//  Created by chirayu-pt6280 on 17/02/23.
//

import Foundation
import UIKit

protocol Theme {

    var backgroundColor : UIColor {get}
    
    var primaryLabel : UIColor {get}
    
    var secondaryLabel : UIColor { get }
    
    var tintColor : UIColor { get set}

}
