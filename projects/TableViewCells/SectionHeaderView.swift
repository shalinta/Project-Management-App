//
//  TableHeaderView.swift
//  projects
//
//  Created by chirayu-pt6280 on 08/03/23.
//

import UIKit

class SectionHeaderView: UITableViewHeaderFooterView {
    
    static let identifier = "header"

    lazy var headerLabel = {
       
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .justified
        
        
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(headerLabel)
        setLabelConstraint()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setApperance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupCell(text:String,fontSize:CGFloat) {
        
        headerLabel.text = text
        headerLabel.font = .systemFont(ofSize: fontSize, weight: .semibold)
        setApperance()
        
    }
    
    
    func setApperance() {
        headerLabel.textColor = currentTheme.secondaryLabel
        
    }
    
    func setLabelConstraint() {
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 5),
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10)
        ])
    }

}
