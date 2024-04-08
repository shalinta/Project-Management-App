//
//  ToDoTableViewCell.swift
//  projects
//
//  Created by chirayu-pt6280 on 13/03/23.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {
    
    static let identifier = "toDo"
    
    var textChanged: ((String) -> Void)?
    var checkBoxHandler:((Bool)->Void)?
   
    override func prepareForReuse() {
        checkBox.isChecked = false
        textView.attributedText = nil
    }
 
    
    
    lazy var checkBox = {
        
       let checkBox = CheckBox()
       checkBox.translatesAutoresizingMaskIntoConstraints = false
       checkBox.addTarget(self, action: #selector(checkBoxClicked), for: .touchUpInside)
        
       return checkBox
        
    }()
    
    
    lazy var textView = {
        
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        textView.delegate = self
        textView.addDoneButtonOnInputView(true)
        
        return textView
        
    }()
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStack()
    }
    
    
    func setupStack() {
        
        contentView.addSubview(checkBox)
        contentView.addSubview(textView)
        
        setupStackViewConstraint()
        checkBoxConstraint()
    }
    
    func setupStackViewConstraint() {
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: contentView.topAnchor),
            textView.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setApperance()
    }
    
    func setupItem(toDo:ToDoItem) {
        print(toDo.toDo,toDo.isComplete)
        checkBox.isChecked = toDo.isComplete
        setTaskAttributedString(text: toDo.toDo)
    }
    
    func setApperance() {
        textView.textColor = currentTheme.tintColor
        
    }
    
    
    func checkBoxConstraint() {
        NSLayoutConstraint.activate([
            checkBox.topAnchor.constraint(equalTo: contentView.topAnchor),
            checkBox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            checkBox.heightAnchor.constraint(equalToConstant: 35),
            checkBox.widthAnchor.constraint(equalToConstant: 35)
        ])
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
    
    @objc  func checkBoxClicked() {
        
        checkBox.isChecked = !checkBox.isChecked
        checkBoxHandler?(checkBox.isChecked)
        setTaskAttributedString(text: textView.text)
        
    }
    
    
    func setTaskAttributedString(text:String) {

        let attributeString:NSMutableAttributedString =  NSMutableAttributedString(string: text)
       
        attributeString.addAttribute(.font, value: UIFont.systemFont(ofSize: 15), range: NSMakeRange(0, attributeString.length))
       
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: currentTheme.tintColor , range: NSMakeRange(0, attributeString.length))
        
        if checkBox.isChecked {
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
            textView.isEditable = false
          } else {
            attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range:  NSMakeRange(0, attributeString.length))
              textView.isEditable = true
        }
        
        textView.attributedText = attributeString
    }

}


extension ToDoTableViewCell:UITextViewDelegate {
        
    func textViewDidChange(_ textView: UITextView) {
                  textChanged?(textView.text)
            }
    
    }

