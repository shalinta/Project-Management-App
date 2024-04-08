//
//  MyWindow.swift
//  projects
//
//  Created by chirayu-pt6280 on 21/02/23.
//

import Foundation
import UIKit

class MyWindow:UIWindow {
    
    override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        applyTheme()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        applyTheme()
    }
    
   private func applyTheme() {
        if traitCollection.userInterfaceStyle == .dark {
            ThemeManager.shared.applyTheme(theme: DarkTheme())
        } else {
            ThemeManager.shared.applyTheme(theme: LightTheme())
        }
    }
}


