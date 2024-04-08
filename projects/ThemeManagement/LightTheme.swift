//
//  BasicTheme.swift
//  projects
//
//  Created by chirayu-pt6280 on 17/02/23.
//light theme - RGB - (74, 144, 226)
//dark theme - RGB - (30, 177, 255)

import Foundation
import UIKit

struct LightTheme:Theme {
    
    var backgroundColor: UIColor = .white
    
    var primaryLabel: UIColor = .black
    
    var secondaryLabel: UIColor = .gray
    
    var tintColor: UIColor = UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1)
    
}


