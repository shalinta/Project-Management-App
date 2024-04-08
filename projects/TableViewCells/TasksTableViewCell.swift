//
//  TasksTableViewCell.swift
//  projects
//
//  Created by chirayu-pt6280 on 03/02/23.
//

import UIKit

class TasksTableViewCell: UITableViewCell {
    
    static let identifier = "taskTableCell"
    
    var checkBoxHandler: ((Bool) -> Void)?
    
    
   private lazy var dateFormatter = {
        
        let dateformatter  = DateFormatter()
        dateformatter.dateStyle  = .medium
        dateformatter.timeStyle = .none
        
        return dateformatter
    }()
    
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        taskNameLabel.attributedText = nil
        
    }
    
    
     private lazy var checkBox = {
        
       let checkBox = CheckBox()
       checkBox.translatesAutoresizingMaskIntoConstraints = false
       checkBox.addTarget(self, action: #selector(checkBoxClicked), for: .touchUpInside)
        
       return checkBox
        
    }()
    
    
    private lazy var taskNameLabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.numberOfLines = 3
        
        return label
        
    }()
    

    
   private lazy var projectNameLabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 3
    
        return label
    }()
    
    
   private lazy var startDateLabel = {
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
       label.textAlignment = .center
        
        return label
        
    }()
    
    private lazy var seperatorLabel = {
         
         let label = UILabel()
         label.translatesAutoresizingMaskIntoConstraints = false
         label.text = "-"
         
         return label
        
     }()
    
    private lazy var endDateLabel = {
         
         let label = UILabel()
         label.font = .systemFont(ofSize: 13)
         label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center

        return label
        
    }()
    // stack holding date,taskName,projectName
   private lazy var verticalStack = {
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 5
        
        return stack
    }()
    
    
    //stack holding taskname,projectName
   private lazy var horizontalStack = {
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = 5

        
        return stack
    }()
    
    
    private lazy var dateHorizontalStack = {
         
         let stack = UIStackView()
         stack.translatesAutoresizingMaskIntoConstraints = false
         stack.axis = .horizontal
         stack.spacing = 5

         
         return stack
     }()
    
    private lazy var emptyView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
        
    }()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
       
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func setupViews() {
        
        contentView.addSubview(horizontalStack)
        
        verticalStack.addArrangedSubview(taskNameLabel)
        verticalStack.addArrangedSubview(projectNameLabel)
        dateHorizontalStack.addArrangedSubview(startDateLabel)
        dateHorizontalStack.addArrangedSubview(seperatorLabel)
        dateHorizontalStack.addArrangedSubview(endDateLabel)
        dateHorizontalStack.addArrangedSubview(emptyView)
        
        verticalStack.addArrangedSubview(dateHorizontalStack)
        
        horizontalStack.addArrangedSubview(checkBox)
        horizontalStack.addArrangedSubview(verticalStack)
        
        setViewConstraints()
        
    }
    
    
   private func setViewConstraints() {
       
       startDateLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
       endDateLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        NSLayoutConstraint.activate([
            
            horizontalStack.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 5),
            horizontalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            horizontalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -5),
            horizontalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -5),
            
            
            checkBox.heightAnchor.constraint(equalToConstant: 33),
            checkBox.widthAnchor.constraint(equalToConstant: 33)
        ])
        
    }
    
    
    func setDetails(task:Task) {
        
        projectNameLabel.text = task.projectName
        startDateLabel.text = dateFormatter.string(from: task.startDate)
        endDateLabel.text = dateFormatter.string(from: task.endDate)
        
        setCheckBox(ticked: task.isCompleted)
        setTaskAttributedString(text: task.name)
        
        setCellAppearance()
    }
    
    
   private func setCheckBox(ticked:Bool) {
        
        checkBox.isChecked = ticked
    }
    
    
  func setCellAppearance() {
        
        taskNameLabel.textColor = currentTheme.primaryLabel
        projectNameLabel.textColor = currentTheme.secondaryLabel
        startDateLabel.textColor = currentTheme.tintColor
    }
  
    
    @objc func checkBoxClicked() {
        
        checkBox.isChecked = !checkBox.isChecked
        
        checkBoxHandler?(checkBox.isChecked)
        
        guard let projectLabel =  projectNameLabel.text else {
            return
        }
        
        setTaskAttributedString(text: projectLabel)
    }
    
   
   private func setTaskAttributedString(text:String) {
        
        let attributeString:NSMutableAttributedString =  NSMutableAttributedString(string: text)
        
        if checkBox.isChecked {
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
          } else {
            attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range:  NSMakeRange(0, attributeString.length))
        }
        
        taskNameLabel.attributedText = attributeString
    }

}
