//
//  AddTaskTableViewVcViewController.swift
//  projects
//
//  Created by chirayu-pt6280 on 01/03/23.
//
//
// ["Projects":[FormItem(title: "Select Project", image: UIImage(systemName: "arrowtriangle.down.fill"), type: .textField)],"Details":[FormItem(title: T"Task Name", image: UIImage(systemName: "circle.circle"), type: .textField),FormItem(title: "Deadline", image: UIImage(systemName: "calendar"), type: .textField)],"Description":[FormItem(title: "desc", image: nil, type: .TextView)]]

import UIKit


enum AddTaskFormSection:String {
  
    case Project
    
    case Name
    
    case Priority

    case StartDate
    
    case EndDate
    
    case Description
}


struct AddTaskForm {
    
    var project:Project?
    var startDate = Date()
    var endDate = Date()
    var name:String?
    var priority:TaskPriority?
    var taskDescription:String?
    
}


protocol AddTaskDelegate {
    func update(task:Task)
}


class AddTaskVc: UIViewController {
    
    var delegate:AddTaskDelegate?
    
    var addTaskForm = AddTaskForm()
        
    let priorityArray = TaskPriority.allCases.map { $0.rawValue }
    
    var savedPressed:Bool = false
    
    let form:[TableViewSection] = [
        
        TableViewSection(title: AddTaskFormSection.Project.rawValue , fields:
                        [TableViewField(title: "Select Project",type: .button)]),
        
        TableViewSection(title: AddTaskFormSection.Name.rawValue, fields:
                        [TableViewField(title: "Task Name", type: .textField),]),
        
        TableViewSection(title: AddTaskFormSection.Priority.rawValue, fields:
                         [TableViewField(title: "priority", type: .picker)]),
        
        TableViewSection(title: AddTaskFormSection.StartDate.rawValue, fields:
                        [TableViewField(title: "StartDate", image: UIImage(systemName: "calendar"),
                         type: .datePicker)]),
        
        TableViewSection(title: AddTaskFormSection.EndDate.rawValue, fields:
                         [TableViewField(title: "EndDate", image: UIImage(systemName: "calendar"), type: .datePicker)]),
        
        TableViewSection(title: AddTaskFormSection.Description.rawValue, fields:
                        [TableViewField(title: "desc", type: .textView)])
        ]
    
  
    

    
    lazy var dateFormatter = {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        return dateFormatter
    }()
    
    
    lazy var addTaskTableView = {
        
        let tableView =  UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.register(TextViewButtonTableViewCell.self, forCellReuseIdentifier: TextViewButtonTableViewCell.identifier)
        tableView.register(TextFieldTableViewCell.self,forCellReuseIdentifier: TextFieldTableViewCell.identifier)
        tableView.register(ButtonTableViewCell.self, forCellReuseIdentifier: ButtonTableViewCell.identifier)
        tableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderView.identifier)
        tableView.separatorColor = .clear
        tableView.backgroundColor = .clear
        
        return tableView
        
    }()
    
   
    lazy var saveBarButton = {
        
        let barButton = UIBarButtonItem()
        barButton.title = "Save"
        barButton.target = self
        barButton.action = #selector(self.save)
        
        return barButton
        
    }()
    
    lazy var cancelBarButton = {
        
        let barButton = UIBarButtonItem()
        barButton.title = "Cancel"
        barButton.target = self
        barButton.action = #selector(self.cancel)
        
        return barButton
    }()
    
    
    init(project:Project?,date:Date?) {
        
        self.addTaskForm.project = project
        self.addTaskForm.endDate = date ?? Date()
        self.addTaskForm.startDate = date ?? Date()
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        additionalSafeAreaInsets  = UIEdgeInsets(top: 5, left: 20, bottom: 0, right: 20)
      
        
        setNavigationBar()
        setupTableView()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        navigationController?.presentationController?.delegate = self
        
        setApperance()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setApperance()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    
        }
    
    
 
    
    func setupTableView() {
        view.addSubview(addTaskTableView)
        setTableViewConstraints()
    }
    
    func setNavigationBar() {
        self.title = "Add Task"
        navigationItem.setRightBarButton(saveBarButton, animated: true)
        navigationItem.setLeftBarButton(cancelBarButton, animated: true)
    }
    

    
    func setApperance() {
        
        view.backgroundColor = currentTheme.backgroundColor
        navigationController?.navigationBar.tintColor = currentTheme.tintColor
        navigationController?.navigationBar.backgroundColor = currentTheme.secondaryLabel.withAlphaComponent(0.1)
    }
    
    
    
    func setTableViewConstraints() {
        
        let keyBoardConstraint = addTaskTableView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
        keyBoardConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            addTaskTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            addTaskTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            addTaskTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            keyBoardConstraint
        ])
    }
    
    
    @objc func projectSelected() {
        
        let projectSelectionVc = SelectProjectVc()
        projectSelectionVc.modalPresentationStyle = .formSheet
        projectSelectionVc.selectionDelegate = self
        projectSelectionVc.selectedProject = addTaskForm.project
        present( UINavigationController(rootViewController: projectSelectionVc), animated: true)
        
    }
    
    @objc func save() {
        
        let generator  = UIImpactFeedbackGenerator(style: .heavy)
        
        savedPressed = true
        addTaskTableView.reloadData()
        
      guard let untaskName = addTaskForm.name,untaskName.trimmingCharacters(in: .whitespaces).isEmpty == false,
            untaskName.count < 120,
            let unpriority = addTaskForm.priority,
            let unproject = addTaskForm.project
            else {
            generator.impactOccurred()
            showToast(message: "Enter all the required Details", seconds: 5)
                
            return
        }
        
        
    let task = Task(name: untaskName,
                startDate: addTaskForm.startDate ,
                endDate: addTaskForm.endDate,
                projectId: unproject.id,
                projectName: unproject.name,
                priority: unpriority,
                description: addTaskForm.taskDescription ?? "",
                isCompleted: false)
        
        
         
        DatabaseHelper.shared.insertInto(table: TaskTable.title,
                        values: [TaskTable.id: .text(task.id.uuidString),
                                TaskTable.name: .text(task.name.trimmingCharacters(in: .whitespaces)),
                                TaskTable.startDate:.double(task.startDate.timeIntervalSince1970),
                                TaskTable.endDate:.double(task.endDate.timeIntervalSince1970),
                                TaskTable.priority: .text(task.priority.rawValue),
                                TaskTable.description: .text(task.description.trimmingCharacters(in:.whitespacesAndNewlines)),
                                TaskTable.isCompleted: .integer(Int64(task.isCompleted.intValue)),
                                TaskTable.projectId: .text(task.projectId.uuidString),
                                TaskTable.projectName: .text(task.projectName)])
          
         delegate?.update(task:task)
         dismiss(animated: true)
    }
    
    
    func showDismissAlert() {
        
        let alert = UIAlertController(title:nil, message:nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { _ in
                    
                }))
        
        alert.addAction(UIAlertAction(title: "Discard Changes", style: .destructive,handler: { _ in
            self.dismiss(animated: true)
        }))
        
        
       if addTaskForm.project == nil,
           addTaskForm.priority == nil,
           addTaskForm.name == nil || addTaskForm.name?.isEmpty == true {
               dismiss(animated: true)
           } else {
               present(alert, animated: true)
           }
    }
   
    
    @objc func cancel() {
    
        showDismissAlert()
     
    }
    
    
    @objc func description() {
        
       let descriptionVc = DescriptionVc(text: addTaskForm.taskDescription ?? "")
        descriptionVc.delegate = self
        
        navigationController?.pushViewController(descriptionVc, animated: true)
        
    }
    
}


extension AddTaskVc:UITableViewDelegate,UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        form.count
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     
        let title = form[section].title
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! SectionHeaderView
        view.setupCell(text: title,fontSize: 18)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
   
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        nil
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        form[section].fields.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
       
        let formItem = form[indexPath.section].fields[indexPath.row]
        
        switch formItem.type {
            
        case .button:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "button") as!ButtonTableViewCell
            cell.configure(forItem: formItem)
            let project = addTaskForm.project
              
            cell.button.addTarget(self, action: #selector(projectSelected), for: .touchUpInside)
            cell.button.setTitle(project?.name ?? "Select Project", for: .normal)
            
            
            if savedPressed {
                if addTaskForm.project != nil {
                    cell.hideValidationLabel()
                } else {
                    cell.showValidationMessage(msg: "Select a Project For the Task")
                }
                
            }
     
            return cell
            
        case .picker:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "textField") as! TextFieldTableViewCell
            let priority = addTaskForm.priority
            
            cell.pickerViewData = priorityArray
            cell.configure(forItem: formItem)
            cell.setText(text:priority?.rawValue)
            
            cell.textChanged = {  text in
                
            guard let unWrappedText = text,unWrappedText.isEmpty == false else {
                 return
            }
                self.addTaskForm.priority = TaskPriority(rawValue: text ?? TaskPriority.Medium.rawValue)
//                self.isModalInPresentation = true
                
            }
            
            
            if savedPressed {
                if addTaskForm.priority != nil {
                    cell.hideValidationMessage()
                } else {
                    cell.showValidationMessage(msg: "Please select a priority for the task")
                }
                
            }
        
            
            return cell
            
        case .datePicker:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "textField") as! TextFieldTableViewCell
           
            if formItem.title == "StartDate" {
                
                cell.selectedDate = self.addTaskForm.startDate
                cell.configure(forItem: formItem)
                cell.textChanged = { _ in
                    self.addTaskForm.startDate = cell.selectedDate
                }
            }
            
            
            if formItem.title == "EndDate" {
                
                cell.selectedDate = self.addTaskForm.endDate
                cell.configure(forItem: formItem)
                cell.textChanged = { _ in
                    self.addTaskForm.endDate = cell.selectedDate
                }
                
            }
            
            
            return cell
            
        case .textField:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "textField") as! TextFieldTableViewCell
            cell.configure(forItem: formItem)
            cell.setText(text: addTaskForm.name)
         
            cell.textChanged = { text in
                
                if formItem.title == "Task Name" {
                    self.addTaskForm.name = text
                    self.navigationController?.isModalInPresentation = true
                }
                
                if self.savedPressed {
                    if let name = self.addTaskForm.name,name.trimmingCharacters(in: .whitespaces).isEmpty == false {
                        if name.count > 120 {
                            cell.showValidationMessage(msg: "Task Name can only be 120 characters")
                        } else {
                            cell.hideValidationMessage()
                        }
                    } else {
                        cell.showValidationMessage(msg: "Enter a name for the Task")
                    }
                    
                    
                }
                
            }
            
      
            
            return cell
   
        case .textView:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TextViewButtonTableViewCell.identifier) as! TextViewButtonTableViewCell
            cell.textView.text = addTaskForm.taskDescription
            cell.button.addTarget(self, action: #selector(getter: description), for: .touchUpInside)
            
            return cell
            
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if form[indexPath.section].title == AddTaskFormSection.Description.rawValue{
            
            return 100
        }
     
        return 70
    }
        
    }
    

    



extension AddTaskVc:ProjectSelectionDelegate {
    
    func showSelectedProject(_ project: Project?) {
        self.addTaskForm.project = project
//        self.navigationController?.isModalInPresentation = true
        addTaskTableView.reloadData()
    }
    
    
}


extension AddTaskVc:DescriptionViewDelegate {
    func setText(text: String) {
        addTaskForm.taskDescription = text
        addTaskTableView.reloadData()
    }
    
    
}


extension AddTaskVc:UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        false
    }
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        showDismissAlert()
    }
}
