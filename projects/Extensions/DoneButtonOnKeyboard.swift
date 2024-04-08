//
//  DoneButtonOnKeyboard.swift
//  projects
//
//  Created by chirayu-pt6280 on 22/02/23.
//

import Foundation
import UIKit

extension UITextView {
    
    func addDoneButtonOnInputView(_ bool:Bool){
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
      
        done.tintColor = currentTheme.tintColor
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        if bool {
            self.inputAccessoryView = doneToolbar } else {
                self.inputAccessoryView = nil
            }
        
    }
    
  
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
    
}

extension UITextField {
    
    func addDoneButtonOnInputView(_ bool:Bool){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
    
        self.inputAccessoryView = doneToolbar
    }
    
    
    func setIcon(_ image: UIImage?) {
        
        guard let unImage = image else {
            rightView = nil
            return
        }
        
       let iconView = UIImageView(frame:
                      CGRect(x: 10, y: 5, width: 20, height: 20))
        
       iconView.image = unImage
        
       let iconContainerView: UIView = UIView(frame:
                      CGRect(x: 20, y: 0, width: 40, height: 30))
       iconContainerView.addSubview(iconView)
        
        
       rightView = iconContainerView
       rightViewMode = .always
    }
    
  
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
    
}

  

