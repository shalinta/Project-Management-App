//
//  Toast message.swift
//  projects
//
//  Created by chirayu-pt6280 on 03/03/23.
//

import Foundation
import UIKit



extension UIViewController {
    
    func showToast(message: String, seconds: Double) {
      
        lazy var toastView = {
            
            let toast = UIView()
            toast.translatesAutoresizingMaskIntoConstraints = false
            toast.backgroundColor = currentTheme.tintColor.withAlphaComponent(0.5)
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = currentTheme.primaryLabel
            label.textAlignment = .center
            
            toast.addSubview(label)
            label.heightAnchor.constraint(equalToConstant: 40).isActive = true
            label.widthAnchor.constraint(equalTo: toast.widthAnchor).isActive = true
            label.centerXAnchor.constraint(equalTo: toast.centerXAnchor).isActive = true
            label.text = message
            
            return toast
            
        }()
        
        self.view.addSubview(toastView)
        
        toastView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        toastView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        toastView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        toastView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor,constant: -10).isActive = true
        toastView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
       
        
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: {toastView.isHidden = true})
    }
}
