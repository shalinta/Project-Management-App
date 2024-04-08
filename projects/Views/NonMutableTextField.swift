//
//  NonMutableTextField.swift
//  projects
//
//  Created by chirayu-pt6280 on 21/03/23.
//

import Foundation
import UIKit

class NonMutableTextField:UITextField {
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if action == #selector(UIResponderStandardEditActions.paste(_:)) ||
           action == #selector(UIResponderStandardEditActions.copy(_:)) ||
           action == #selector(UIResponderStandardEditActions.cut(_:)) {
                return false
            }
           
            return super.canPerformAction(action, withSender: sender)
    }
    
   
}
