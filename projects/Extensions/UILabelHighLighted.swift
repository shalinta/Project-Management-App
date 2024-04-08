//
//  UILabelHighLighted.swift
//  projects
//
//  Created by chirayu-pt6280 on 23/03/23.
//

import Foundation
import UIKit

extension UILabel {
    
    func setHighlighted(_ text: String,searchString: String?) {
        
        guard let unsearchString = searchString else {
            self.text = text
            return
        }
        
        let attributedText = NSMutableAttributedString(string: text)
        let range = NSString(string: text).range(of: unsearchString, options: .caseInsensitive)
        let highlightedAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
        
        attributedText.addAttributes(highlightedAttributes, range: range)
        self.attributedText = attributedText
    }
}
