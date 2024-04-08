//
//  ThemeManager.swift
//  projects
//
//  Created by chirayu-pt6280 on 17/02/23.
//

import Foundation
import UIKit

var currentTheme:Theme = LightTheme()

class ThemeManager {
   
    private init() {
        
    }
    
   static let shared = ThemeManager()
    
    
    func applyTheme(theme:Theme) {
          currentTheme = theme
    }

}
