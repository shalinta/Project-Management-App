//
//  ProjectTableViewCell.swift
//  projects
//
//  Created by chirayu-pt6280 on 07/02/23.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {

    static let identifier = "ProjectTableCell"
    
    private lazy var dateFormatter = {
        
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .medium
        dateformatter.timeStyle = .none
        
        return dateformatter
    }()
    
   
    
   private lazy var projectNameLabel = {
        
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 15, weight: .bold)
        nameLabel.numberOfLines = 3
        
        return nameLabel
        
    }()
    
   private lazy var startDateLabel = {
        
        let startDate = UILabel()
        startDate.translatesAutoresizingMaskIntoConstraints = false
        startDate.font = .systemFont(ofSize: 13, weight: .semibold)
  
        return startDate
    
    }()
    
   private lazy var endDateLabel = {
        
        let endDate = UILabel()
        endDate.translatesAutoresizingMaskIntoConstraints = false
        endDate.font = .systemFont(ofSize: 13, weight: .bold)
  
        return endDate
        
    }()
    
    
    
   private lazy var seperatorLabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "-"
        
        return label
    }()
    
   private lazy var clockImage = {
        
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "clock")
        
        return image
    }()

    
   private lazy var datehorizontalStack = {
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 5
        stack.alignment = .center
        
        return stack
        
    }()

    

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStackViews()
    }
    
    
    func setupStackViews() {
        
        datehorizontalStack.addArrangedSubview(clockImage)
        datehorizontalStack.addArrangedSubview(startDateLabel)
        datehorizontalStack.addArrangedSubview(seperatorLabel)
        datehorizontalStack.addArrangedSubview(endDateLabel)
        
        contentView.addSubview(projectNameLabel)
        contentView.addSubview(datehorizontalStack)
        
        
        setStackViewConstraints()
    }
    
    
    func setAppearance() {
        
        projectNameLabel.textColor = currentTheme.primaryLabel
        startDateLabel.textColor = currentTheme.secondaryLabel
        endDateLabel.textColor =  currentTheme.tintColor
        clockImage.tintColor = currentTheme.primaryLabel

    }
    
    
    
    func setStackViewConstraints() {
        
        NSLayoutConstraint.activate([
            projectNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            projectNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            projectNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10),
            
            datehorizontalStack.topAnchor.constraint(equalTo: projectNameLabel.bottomAnchor,constant: 10),
            datehorizontalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            datehorizontalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10),
        
        ])
  }
    
    
    func setDetails(project:Project) {
        
        self.projectNameLabel.text = project.name
        self.startDateLabel.text = dateFormatter.string(from: project.startDate)
        self.endDateLabel.text = dateFormatter.string(from: project.endDate)
        setAppearance()
        
    }

   
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
    
}
