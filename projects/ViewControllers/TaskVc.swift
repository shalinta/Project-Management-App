//
//  TaskVc.swift
//  projects
//
//  Created by chirayu-pt6280 on 10/03/23.
//

import UIKit

class TaskVc: UIViewController {
    
    
    var tasksForm:[TableViewSection] =  [
        
        TableViewSection(title: "Start Date", fields:
            [TableViewField(title: "StartDate", image: UIImage(systemName: "calendar"), type: .datePicker)]),
        
        TableViewSection(title: "End Date", fields:
            [TableViewField(title: "Deadline", image: UIImage(systemName: "calendar"), type: .datePicker)]),
        
        TableViewSection(title: "", fields:
            [TableViewField(title: "Attachments", image: nil, type: .button),
             TableViewField(title: "CheckList", image: nil, type: .button)]),
        
       TableViewSection(title: "Description", fields:
             [TableViewField(title: "", type: .textView)])
    ]
    
    
    var taskForVc:Task
    var priorityArray = TaskPriority.allCases
    
    init(taskForVc: Task) {
        self.taskForVc = taskForVc
        super.init(nibName: nil, bundle: nil)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var taskNameTextView = {
        
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 21 ,weight: .bold)
        textView.addDoneButtonOnInputView(true)
        
        return textView
    }()
    
    
    lazy var table = {
        
        let tableView =  UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ButtonTableViewCell.self, forCellReuseIdentifier: ButtonTableViewCell.identifier)
        tableView.register(TextFieldTableViewCell.self, forCellReuseIdentifier: TextFieldTableViewCell.identifier)
        tableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderView.identifier)
        tableView.register(TextViewButtonTableViewCell.self, forCellReuseIdentifier: TextViewButtonTableViewCell.identifier)
        
        tableView.allowsSelection = false
        tableView.separatorColor = .clear
        tableView.backgroundColor = .clear
        
        return tableView
        
    }()
    
    
    lazy var priorityTextField = {
        
        let textField = NonMutableTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Priority"
        textField.textAlignment = .center
        textField.tintColor = .clear
        textField.layer.cornerRadius = 15
        textField.backgroundColor = .systemFill
        textField.inputView = pickerView
        textField.addDoneButtonOnInputView(true)
        
        return textField
        
    }()
    
    private lazy var checkBox = {
       
      let checkBox = CheckBox()
      checkBox.translatesAutoresizingMaskIntoConstraints = false
        checkBox.addTarget(self, action: #selector(checkBoxClicked), for: .touchUpInside)
       
      return checkBox
       
   }()
    
    @objc func checkBoxClicked() {
        
        checkBox.isChecked = !checkBox.isChecked
        
        taskForVc.isCompleted = checkBox.isChecked
        
        DatabaseHelper.shared.update(tableName: TaskTable.title, columns:
                                        [TaskTable.isCompleted:.integer(Int64(taskForVc.isCompleted.intValue))],
                                whereArugment: [TaskTable.id:.text(taskForVc.id.uuidString)])
    
        
        if checkBox.isChecked {
            showToast(message: "Marked completed", seconds: 2)
        }
    }
    
    lazy var moreBarButton = {
        
        let barButton = UIBarButtonItem()
        barButton.image = UIImage(systemName: "ellipsis.circle")
        barButton.target = self
        barButton.primaryAction = nil
        
        return barButton
        
        
    }()
    
    
    lazy var pickerView = {
        
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        
        return picker
    }()
    
    
    lazy var backGroundView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
        
    }()
    
    
    func setupView() {
        
        view.addSubview(backGroundView)
      
        
        NSLayoutConstraint.activate([
            backGroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backGroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backGroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backGroundView.bottomAnchor.constraint(equalTo: priorityTextField.bottomAnchor,constant: 20)
        ])
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.setRightBarButton(moreBarButton, animated: false)
        additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        setupCheckBox()
        setupTextView()
        setupPriorityTextField()
        setupView()
        setupTableView()
        setValues()
        setMoreButtonMenu()
        
        view.bringSubviewToFront(checkBox)
        view.bringSubviewToFront(taskNameTextView)
        view.bringSubviewToFront(priorityTextField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
        table.reloadData()
        setApperance()
        
    }
    
    func setupCheckBox() {
        view.addSubview(checkBox)
        
        NSLayoutConstraint.activate([
            checkBox.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            checkBox.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            checkBox.heightAnchor.constraint(equalToConstant: 44),
            checkBox.widthAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setApperance()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        
        guard taskNameTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false,
              taskNameTextView.text.count <= 120 else {
            
              return
        }
        
        
        DatabaseHelper.shared.update(tableName: TaskTable.title,
            columns: [TaskTable.name:.text(taskNameTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)),
                      TaskTable.startDate: .double(taskForVc.startDate.timeIntervalSince1970),
                      TaskTable.endDate:.double(taskForVc.endDate.timeIntervalSince1970),
                      TaskTable.priority:.text(taskForVc.priority.rawValue),
                      TaskTable.description:.text(taskForVc.description),
                      TaskTable.isCompleted:.integer(Int64(taskForVc.isCompleted.intValue)),
                      TaskTable.projectId:.text(taskForVc.projectId.uuidString),
                      TaskTable.projectName:.text(taskForVc.projectName)
                        ]
                    ,whereArugment: [
                       TaskTable.id: .text(taskForVc.id.uuidString)
                                     ])
    }
    
    
    func setApperance() {
        
        navigationController?.navigationBar.tintColor = currentTheme.tintColor
        taskNameTextView.textColor = currentTheme.tintColor
        priorityTextField.backgroundColor = currentTheme.tintColor.withAlphaComponent(0.5)
        pickerView.setValue(currentTheme.tintColor, forKeyPath: "textColor")
        pickerView.backgroundColor = currentTheme.backgroundColor
        backGroundView.backgroundColor = currentTheme.backgroundColor
        view.backgroundColor = .tertiarySystemGroupedBackground
      
    }
    
    
    func setValues() {
        self.taskNameTextView.text = taskForVc.name
        self.priorityTextField.text = taskForVc.priority.rawValue
        self.checkBox.isChecked = taskForVc.isCompleted
    }
    
    
    func setupTableView() {
        
        view.addSubview(table)
        
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: priorityTextField.bottomAnchor,constant: 20),
            table.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
        ])
    }
    
    func setupPriorityTextField() {
        
        view.addSubview(priorityTextField)
        
        NSLayoutConstraint.activate([
            priorityTextField.topAnchor.constraint(equalTo: taskNameTextView.bottomAnchor,constant: 15),
            priorityTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            priorityTextField.widthAnchor.constraint(equalToConstant: 80),
            priorityTextField.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    func setupTextView() {
        
        
        view.addSubview(taskNameTextView)
        
        NSLayoutConstraint.activate([
            taskNameTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            taskNameTextView.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor),
            taskNameTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10)
        ])
        
        
    }
    
    func setMoreButtonMenu() {
        
        let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), identifier: nil, discoverabilityTitle: nil, attributes: .destructive, state: .off , handler: { [self]
            action in
            
            self.deleteTask()
          
        })
        
        let options = [delete]
        
        
        moreBarButton.menu = UIMenu(title:"", image: nil, identifier: nil, options: .singleSelection, children:
        options)
        
    }
    
    
    @objc func checkLists() {
        navigationController?.pushViewController(CheckListToDoVc(task: taskForVc), animated: true)
    }
    
    func getAllAttachmentsPaths()->[URL] {
        
        var output = [Dictionary<String,Any>]()
        var attachments = [URL]()
        
        output = DatabaseHelper.shared.selectFrom(table: AttachmentTable.taskAttachmentsTable, columns: [AttachmentTable.path], wherec: [AttachmentTable.associatedId:.text(taskForVc.id.uuidString)])
        
        output.forEach { row in
            
            guard let path = row[AttachmentTable.path] as? String else {
                return
            }
            
            guard let url = URL(string: path) else {
                return
            }
            
            attachments.append(url)
            
        }
        
        return attachments
    }
    
    
     func deleteTask() {
        
        let alert = UIAlertController(title: "Delete Task", message: "This task will be deleted permanently",         preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
                    
                }))
        
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.default, handler: { _ in
            
            self.getAllAttachmentsPaths().forEach { url in
                try? FileManager.default.removeItem(at: url)
            }
            
            DatabaseHelper.shared.deleteFrom(tableName: TaskTable.title, whereC:             [TaskTable.id:.text(self.taskForVc.id.uuidString)])
            
            self.navigationController?.popViewController(animated: true)
                    
            }))
        
        
        present(alert, animated: true)
        
           
    }
    
    
    
    
    @objc func attachments() {
       
        let attachmentsVc = AttachmentsVc(id: taskForVc.id, attachmentsFor: .Tasks)
        navigationController?.pushViewController(attachmentsVc, animated: true)
    }
  
    
    @objc func description() {
        
        let descriptionVc = DescriptionVc(text: taskForVc.description)
        descriptionVc.delegate = self
        navigationController?.pushViewController(descriptionVc, animated: true)
        
    }
    
    
    func getNumberOfToDoForTask()->Int {
        
        var output = Array<Dictionary<String,Any>>()
        
        output = DatabaseHelper.shared.selectFrom(
            table: ToDoTable.title,
            columns: nil,
            wherec:[ToDoTable.taskId:.text(taskForVc.id.uuidString)])
        
        return output.count
    }
    
    func getNumberOfAttachmentsForTask() -> Int {
        
        var output = Array<Dictionary<String,Any>>()
        
        output = DatabaseHelper.shared.selectFrom(table: AttachmentTable.taskAttachmentsTable, columns: nil, wherec: [AttachmentTable.associatedId: .text(taskForVc.id.uuidString)])
        
        return output.count
    }
}
    
    
    
   


extension TaskVc:UIPickerViewDelegate,UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        priorityArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        priorityArray[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        priorityTextField.text = priorityArray[row].rawValue
        taskForVc.priority = priorityArray[row]
    }
    
}


extension TaskVc:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        tasksForm.count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasksForm[section].fields.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        let title = tasksForm[section].title
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderView.identifier) as! SectionHeaderView
        view.setupCell(text: title,fontSize: 18)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = tasksForm[indexPath.section].fields[indexPath.row]
        
        switch item.type {
            
        case .datePicker:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier) as! TextFieldTableViewCell
            
            if item.title == "Deadline" {
                
                cell.selectedDate = taskForVc.endDate
                cell.configure(forItem: item)
                cell.textChanged = { _ in
                    self.taskForVc.endDate = cell.selectedDate
                }
                
            }
            
            if item.title == "StartDate" {
                
                cell.selectedDate = taskForVc.startDate
                cell.configure(forItem: item)
                cell.textChanged = { _ in
                    self.taskForVc.startDate = cell.selectedDate
                }
            }
      
            
            return cell
            
        case .button:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.identifier) as! ButtonTableViewCell
            cell.configure(forItem: item)
            
            if item.title == "Attachments" {
                let numberOfAttachments = getNumberOfAttachmentsForTask()
                
                if numberOfAttachments != 0 {
                    cell.setTitle(text: "Attachments (\(numberOfAttachments))")
                }
                
                cell.button.addTarget(self, action: #selector(attachments), for: .touchUpInside)
            }
            
            if item.title == "CheckList" {
                let toDoCount = getNumberOfToDoForTask()
                
                if toDoCount != 0 {
                    cell.setTitle(text: "CheckList (\(toDoCount))")
                }
                
                cell.button.addTarget(self, action: #selector(checkLists), for: .touchUpInside)
            }
            
            return cell
            
        case .textView:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TextViewButtonTableViewCell.identifier) as! TextViewButtonTableViewCell
            cell.setTextViewText(text: taskForVc.description)
            cell.button.addTarget(self, action: #selector(getter: description), for: .touchUpInside)
            
            return cell
            
        case .textField:
            
            return UITableViewCell()
            
        case .picker:
            
            return UITableViewCell()
            
        }
    
    }

    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
        let formItem = tasksForm[indexPath.section].fields[indexPath.row]
        
        if formItem.type == .textView {
            return 120
        }
        
       return 60
    }
    
}

extension TaskVc: DescriptionViewDelegate {
    func setText(text: String) {
        taskForVc.description = text
        table.reloadData()
    }
    
    
}
