//
//  ButtonTableViewCell.swift
//  projects
//
//  Created by chirayu-pt6280 on 02/03/23.
//

import UIKit



class ButtonTableViewCell: UITableViewCell {

  
    static let identifier = "button"
   
   override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    lazy var button = {
        
        var config = UIButton.Configuration.plain()
        config.imagePlacement = .trailing
        config.titleAlignment = .leading
        config.imagePadding = 200
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1

        return button
        
    }()
    
    lazy var validationLabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.isHidden = true
        label.textColor = .red
        
        return label
        
    }()
    
    
    override func prepareForReuse() {
        button.removeTarget(nil, action: nil, for: .allEvents)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        contentView.addSubview(button)
        contentView.addSubview(validationLabel)

        
        setButtonConstraints()
        setApperance()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setApperance()
    }

    func setApperance() {
        
        button.setTitleColor(currentTheme.tintColor, for: .normal)
        button.layer.borderColor = currentTheme.tintColor.cgColor
        button.backgroundColor = currentTheme.backgroundColor

    }
    
 
    
    func setButtonConstraints() {
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            button.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6),
            
            validationLabel.topAnchor.constraint(equalTo: button.bottomAnchor,constant: 5),
            validationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            validationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            validationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: 0)
        ])
        
    }
    
    func setTitle(text:String) {
        button.setTitle(text, for: .normal)
    }

    
    func configure(forItem:TableViewField) {
        
        self.button.setTitle(forItem.title, for: .normal)
        self.button.setImage(forItem.image, for: .normal)
        
        setApperance()
    }
    
    func showValidationMessage(msg:String) {
        
        validationLabel.text = msg
        validationLabel.isHidden = false
        
    }
    
    func hideValidationLabel() {
        validationLabel.isHidden  = true
    }
    
}
