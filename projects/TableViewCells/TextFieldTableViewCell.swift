//
//  TextFieldTableViewTableViewCell.swift
//  projects
//
//  Created by chirayu-pt6280 on 01/03/23.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {
    
    static let identifier = "textField"

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var textChanged: ((String?) -> Void)?
    var selectedDate:Date!
    var pickerViewData:[String]?
    

    override func prepareForReuse() {
    
        textField.text = ""
        textField.inputView = nil
        textField.setIcon(nil)
        validationLabel.isHidden = true
    }
    
 
    private lazy var dateFormatter = {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        return formatter
    }()
    
    
    lazy var validationLabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.textColor = .red
        label.font = .systemFont(ofSize: 14, weight: .regular)
    
        return label
    }()
        
    lazy var textField = {

        let textField = NonMutableTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .left
        textField.addDoneButtonOnInputView(true)
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        textField.font = .systemFont(ofSize: 18)
        textField.layer.cornerRadius = 10
     
        
        return textField
    }()
    
    lazy var underLine = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = currentTheme.tintColor
        
        return line
    }()
    
    lazy var datePicker = {
        
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
      //  datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        datePicker.preferredDatePickerStyle = .wheels
        
         return datePicker
    }()
    
    
   private lazy var priorityPickerView =  {
        
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        
        return picker
        
    }()
    
    func setPadding() {
        
        let paddingView = UIView(frame: CGRectMake(0, 0, 15, self.textField.frame.height))
        
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
    
    func showValidationMessage(msg:String) {
        
        validationLabel.text = msg
        validationLabel.isHidden = false
        
    }
    
    func hideValidationMessage() {
        validationLabel.isHidden = true
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textField)
        contentView.addSubview(underLine)
        contentView.addSubview(validationLabel)
        self.backgroundColor = .clear
        
//        setPadding()
        setTextFieldConstraints()
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setApperance()
    }
    
    
    func setApperance() {
        
        self.textField.tintColor = currentTheme.tintColor
        self.textField.backgroundColor = .clear
        
        priorityPickerView.setValue(currentTheme.tintColor, forKeyPath: "textColor")
        priorityPickerView.backgroundColor = currentTheme.backgroundColor
        datePicker.setValue(currentTheme.tintColor, forKeyPath: "textColor")
        datePicker.backgroundColor = currentTheme.backgroundColor
        contentView.layer.borderColor = currentTheme.primaryLabel.cgColor
        
    }
    
    
    func setText(text:String?) {
        self.textField.text = text
    }
    

    
    func setTextFieldConstraints() {
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textField.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6),
            
            underLine.topAnchor.constraint(equalTo: textField.bottomAnchor,constant: 3),
            underLine.heightAnchor.constraint(equalToConstant: 1),
            underLine.widthAnchor.constraint(equalTo: contentView.widthAnchor),
           
            
            validationLabel.topAnchor.constraint(equalTo: underLine.bottomAnchor,constant: 3),
            validationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            validationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            validationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: 0)
        ])
        
    
    }
    
    
    
    func configure(forItem:TableViewField) {
        
       textField.placeholder = forItem.title
        
        textField.setIcon(forItem.image)
        
        
        if forItem.type == .datePicker {
            self.textField.inputView = datePicker
            self.textField.text = dateFormatter.string(from: selectedDate)
        }
        
        
        if forItem.type == .picker {
            self.textField.inputView = priorityPickerView
            textField.clearButtonMode = .never
        }
        
        
        setApperance()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
  @objc func dateChanged() {
      self.selectedDate = datePicker.date
      self.textField.text = dateFormatter.string(from: selectedDate)
    }

    
   
}


extension TextFieldTableViewCell:UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      
        print(#function)
        textChanged?(textField.text)
        validationLabel.isHidden = true
        
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
     
        print(#function)
        textChanged?("")
        self.selectedDate = Date()
        
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(#function)
        textChanged?(textField.text)
    }
    
  
}



extension TextFieldTableViewCell:UIPickerViewDelegate,UIPickerViewDataSource {
  
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       
        guard let dataSource = pickerViewData else {
            return 0
        }
        
        return dataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        pickerViewData?[row]
    }

    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.textField.text = pickerViewData?[row]
        textChanged?(pickerViewData?[row])
    }
    
    
    
    
}
