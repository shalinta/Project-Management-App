//
//  AttachmentsTableViewCell.swift
//  projects
//
//  Created by chirayu-pt6280 on 24/03/23.
//

import UIKit

class AttachmentsTableViewCell: UITableViewCell {
    
    static let identifier = "attachments"
    
    lazy var attachmentImage = {
        
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints =  false
        
        return image
        
    }()
    
    lazy var label  = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .bold)
        
        return label
        
    }()
    
    lazy var horizontalStack = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupStackView() {
        
        horizontalStack.addArrangedSubview(attachmentImage)
        horizontalStack.addArrangedSubview(label)
        contentView.addSubview(horizontalStack)
        
        NSLayoutConstraint.activate([
            
            horizontalStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            horizontalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            horizontalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            horizontalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            attachmentImage.heightAnchor.constraint(equalToConstant: 40),
            attachmentImage.widthAnchor.constraint(equalToConstant: 40)
        ])
        
    }
    
    func configure(for attachment:Attachment) {
        
        self.label.text = attachment.name
        
        switch attachment.type {
        case .Pdf:
            attachmentImage.image = UIImage(named: "pdf")
        case .Image:
            attachmentImage.image = UIImage(named: "image")
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
