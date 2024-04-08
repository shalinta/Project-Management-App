//
//  CheckBox.swift
//  projects
//
//  Created by chirayu-pt6280 on 03/02/23.
//

import UIKit

class CheckBox: UIButton {
    
    private var uncheckedImage = UIImage(named: "uncheckedCheckbox")?.withTintColor(currentTheme.tintColor)
    private var checkedImage = UIImage(named: "checkedCheckbox")?.withTintColor(currentTheme.tintColor)
    
    
    var isChecked = false {
       
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, for: .normal)
            } else {
                self.setImage(uncheckedImage, for: .normal)
           }
        }
    }
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.setImage(uncheckedImage, for: .normal)
        
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        uncheckedImage = UIImage(named: "uncheckedCheckbox")?.withTintColor(currentTheme.tintColor)
        checkedImage = UIImage(named: "checkedCheckbox")?.withTintColor(currentTheme.tintColor)
    }
    
   private func setImageSize() {
        
        self.contentVerticalAlignment = .fill
        self.contentHorizontalAlignment = .fill
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
