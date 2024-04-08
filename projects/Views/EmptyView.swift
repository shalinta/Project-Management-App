//
//  EmptyView.swift
//  projects
//
//  Created by chirayu-pt6280 on 20/03/23.
//

import UIKit

class EmptyView: UIView {
    
    lazy var emptyListImageView = {
        
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        
        return image
    }()
    
    
    lazy var button = {
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    lazy var boldMessage = {
        
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 16, weight: .bold)
        nameLabel.numberOfLines = 3
        nameLabel.textAlignment = .center
        
        return nameLabel
        
    }()
    
    
    lazy var lightMessage = {
        
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 12, weight: .light)
        nameLabel.numberOfLines = 3
        nameLabel.textAlignment = .center
        
        return nameLabel
        
    }()


   private lazy var verticalStack = {
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 5
        
        return stack
        
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
  private func setupStack() {
        
        self.addSubview(emptyListImageView)
        self.addSubview(verticalStack)
        addSubview(button)
        
        verticalStack.addArrangedSubview(boldMessage)
        verticalStack.addArrangedSubview(lightMessage)
        
        NSLayoutConstraint.activate([
            emptyListImageView.topAnchor.constraint(equalTo: topAnchor),
            emptyListImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyListImageView.heightAnchor.constraint(equalToConstant: 80),
            emptyListImageView.widthAnchor.constraint(equalToConstant: 80)
            ])
        
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: emptyListImageView.bottomAnchor,constant: 10),
            verticalStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            verticalStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            verticalStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
      NSLayoutConstraint.activate([
        button.topAnchor.constraint(equalTo: topAnchor),
        button.leadingAnchor.constraint(equalTo: leadingAnchor),
        button.bottomAnchor.constraint(equalTo: bottomAnchor),
        button.trailingAnchor.constraint(equalTo: trailingAnchor)
      ])

    }
    
    
    
}
