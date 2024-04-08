//
//  DarkTheme.swift
//  projects
//
//  Created by chirayu-pt6280 on 21/02/23.
//

import Foundation
import UIKit

struct DarkTheme:Theme {
  
    var backgroundColor: UIColor = .black
    
    var primaryLabel: UIColor = .white
    
    var secondaryLabel: UIColor = .white.withAlphaComponent(0.8)
    
    var tintColor: UIColor = UIColor(red: 30/255, green: 177/255, blue: 255/255, alpha: 1)
    
}
