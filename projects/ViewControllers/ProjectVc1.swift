//
//  ProjectVc1.swift
//  projects
//
//  Created by chirayu-pt6280 on 03/03/23.
//

import UIKit

class ProjectVc1: UIViewController {

    var projectForVc:Project
    let status = ProjectStatus.allCases

    
    let tableSections:[TableViewSection] = [
        
            TableViewSection(title: "Start-Date", fields:
                   [TableViewField(title:"StartDate", image: UIImage(systemName: "calendar"), type: .datePicker)]),
            
            TableViewSection(title: "End-Date", fields: [
                TableViewField(title: "EndDate", image: UIImage(systemName: "calendar"), type: .datePicker)
              ]),
           
            TableViewSection(title: "", fields:
                   [TableViewField(title: "Attachments", type: .button),
                    TableViewField(title: "Tasks", type: .button)
                    ]),
            
            TableViewSection(title: "Description", fields:
                   [TableViewField(title: "", type: .textView)]),
        
            ]
    
    
    init(projectForVc:Project) {
        self.projectForVc = projectForVc
        super.init(nibName: nil, bundle: nil)
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var projectNameTextView = {
        
          let textView = UITextView()
          textView.translatesAutoresizingMaskIntoConstraints = false
          textView.isScrollEnabled = false
          textView.font = .systemFont(ofSize: 21 ,weight: .bold)
          textView.addDoneButtonOnInputView(true)
          textView.backgroundColor  = .clear
        
          return textView
    }()
    
    
    lazy var backGroundView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
        
    }()
    

    
    lazy var statusTextField = {
        
        let textField = NonMutableTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Status"
        textField.textAlignment = .center
        textField.tintColor = .clear
        textField.layer.cornerRadius = 14
        textField.inputView = pickerView
        textField.addDoneButtonOnInputView(true)
        
        return textField
    }()
    
    
    lazy var table = {
        
        let tableView =  UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
        tableView.register(ButtonTableViewCell.self, forCellReuseIdentifier: "button")
        tableView.register(TextViewButtonTableViewCell.self, forCellReuseIdentifier: "textView")
        tableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "header")
        tableView.register(TextFieldTableViewCell.self, forCellReuseIdentifier: "text")
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        
        return tableView
        
    }()
    
    lazy var moreBarbutton = {
        
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
    
    
    func setupBackgroundView() {
        
        view.addSubview(backGroundView)
        
        NSLayoutConstraint.activate([
            backGroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backGroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backGroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backGroundView.bottomAnchor.constraint(equalTo: statusTextField.bottomAnchor,constant: 20)
        ])
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        setupNavigationBar()
        setupProjectNameView()
        setupStatusTextField()
        setupBackgroundView()
        setupTableView()
        setupValues()
        setMoreButtonMenu()
        
        view.bringSubviewToFront(statusTextField)
        view.bringSubviewToFront(projectNameTextView)
    }
    
    func setupNavigationBar() {
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.setRightBarButton(moreBarbutton, animated: true)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        table.reloadData()
        setApperance()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setApperance()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard projectNameTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false,
              projectNameTextView.text.count <= 120 else {
              return
        }
        
        
        DatabaseHelper.shared.update(tableName: ProjectTable.title, columns: [
            ProjectTable.name : .text(projectNameTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)),
            ProjectTable.startDate : .double(projectForVc.startDate.timeIntervalSince1970),
            ProjectTable.endDate: .double(projectForVc.endDate.timeIntervalSince1970),
            ProjectTable.description: .text(projectForVc.description),
            ProjectTable.status: .text(projectForVc.status.rawValue)],
                                     whereArugment: [ProjectTable.id:.text(projectForVc.id.uuidString)])
        
        DatabaseHelper.shared.update(tableName: TaskTable.title, columns:
                                        [TaskTable.projectName:.text(projectNameTextView.text)], whereArugment: [TaskTable.projectId:.text(projectForVc.id.uuidString)])

    }
    
    func setMoreButtonMenu() {
        
        let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), identifier: nil, discoverabilityTitle: nil, attributes:.destructive, state: .off , handler: { [self]
            action in
            
            self.deleteProject()
          
        })
        
        
        let options = [delete]
        
        moreBarbutton.menu = UIMenu(title:"", image: nil, identifier: nil, options: .destructive, children:
        options)
        
    }
    
    
    
    func setupValues() {
        
        projectNameTextView.text = projectForVc.name
        statusTextField.text = projectForVc.status.rawValue
        
    }
    
    
    
    func setupStatusTextField() {
        view.addSubview(statusTextField)
        
        NSLayoutConstraint.activate([
            statusTextField.topAnchor.constraint(equalTo: projectNameTextView.bottomAnchor,constant: 15),
            statusTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            statusTextField.widthAnchor.constraint(equalToConstant: 80),
            statusTextField.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    

    
    func setupTableView() {
      
        view.addSubview(table)
        
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: statusTextField.bottomAnchor,constant: 20),
            table.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor,constant: -10)
        ])
    }
    
   
    func setupProjectNameView() {
        
        view.addSubview(projectNameTextView)
        
        NSLayoutConstraint.activate([
            projectNameTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            projectNameTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            projectNameTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -20)
        ])
        
    }
    
    
    
    func setApperance() {
        
        view.backgroundColor  = currentTheme.backgroundColor
        projectNameTextView.textColor = currentTheme.tintColor
        statusTextField.backgroundColor = currentTheme.tintColor.withAlphaComponent(0.5)
        pickerView.setValue(currentTheme.tintColor, forKeyPath: "textColor")
        pickerView.backgroundColor = currentTheme.backgroundColor
        view.backgroundColor = .tertiarySystemGroupedBackground
        backGroundView.backgroundColor = currentTheme.backgroundColor
        
    }

    
    
    
    @objc func attachments() {
        
        let attachMentsVc =  AttachmentsVc(id: projectForVc.id, attachmentsFor: .Projects)
      
        navigationController?.pushViewController(attachMentsVc, animated: true)
    }
    
    
    
    @objc func tasks() {
        
        let tasksVc = YourTasksVc(stateForVc: .TaskForProject)
        tasksVc.project = projectForVc
        navigationController?.pushViewController(tasksVc, animated: true)
    
    }
    
    
    
    func getNumberOfTaskForProject()->Int {
        
        var output = Array<Dictionary<String,Any>>()
        
        output = DatabaseHelper.shared.selectFrom(
            table: TaskTable.title,
            columns: nil,
            wherec:[TaskTable.projectId:.text(projectForVc.id.uuidString)])
        
        return output.count
    }
    
    
    
    func getNumberOfAttachmentsForProject() -> Int {
        
        var output = Array<Dictionary<String,Any>>()
        
        output = DatabaseHelper.shared.selectFrom(table: AttachmentTable.projectAttachmentTable, columns: nil, wherec: [AttachmentTable.associatedId: .text(projectForVc.id.uuidString)])
        
        return output.count
    }
    
    
    
    @objc func description() {
        let descriptionVc = DescriptionVc(text: projectForVc.description)
        descriptionVc.delegate = self
        navigationController?.pushViewController(descriptionVc, animated: true)
    }
    
    
    func getAllAttachmentsPaths()->[URL] {
        
        var output = [Dictionary<String,Any>]()
        var attachments = [URL]()
        
        output = DatabaseHelper.shared.selectFrom(table: AttachmentTable.projectAttachmentTable, columns: [AttachmentTable.path], wherec: [AttachmentTable.associatedId:.text(projectForVc.id.uuidString)])
        
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
    
    
     func deleteProject() {
        
        let alert = UIAlertController(title: "Delete Project",
                                      message: "This project will be deleted permanently,along with all the task associated with it",preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
                    
                }))
        
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.default, handler: { _ in
            
            
            self.getAllAttachmentsPaths().forEach { url in
                try? FileManager.default.removeItem(at: url)
            }
            
            DatabaseHelper.shared.deleteFrom(tableName: ProjectTable.title, whereC:             [TaskTable.id:.text(self.projectForVc.id.uuidString)])
            
            self.navigationController?.popViewController(animated: true)
                    
            }))
        
        
        present(alert, animated: true)
    }


}

extension ProjectVc1:UIPickerViewDelegate,UIPickerViewDataSource {
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        status.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        status[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.statusTextField.text = status[row].rawValue
        projectForVc.status = status[row]
    }
    
}





extension ProjectVc1:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        tableSections.count
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableSections[section].fields.count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let title = tableSections[section].title
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! SectionHeaderView
        view.setupCell(text: title,fontSize: 18)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let formItem = tableSections[indexPath.section].fields[indexPath.row]
        
        if formItem.type == .textView {
            return 100
        }
        
       return 60
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let formItem = tableSections[indexPath.section].fields[indexPath.row]
        
        switch formItem.type {
            
        case .datePicker:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "text", for: indexPath) as! TextFieldTableViewCell
           
            if formItem.title == "StartDate" {
                cell.selectedDate = projectForVc.startDate
                cell.configure(forItem: formItem)
                cell.textChanged = { _ in
                    self.projectForVc.startDate = cell.selectedDate
                }
            }
           
            if formItem.title == "EndDate" {
                cell.selectedDate = projectForVc.endDate
                cell.configure(forItem: formItem)
                cell.textChanged = { _ in
                    self.projectForVc.endDate = cell.selectedDate
                }
            }
            
            return cell
            
        case .button:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "button", for: indexPath) as! ButtonTableViewCell
            cell.configure(forItem: formItem)
            
            if formItem.title == "Attachments" {
                let numberOfAttachments = getNumberOfAttachmentsForProject()
                if numberOfAttachments != 0 {
                    cell.setTitle(text: "Attachments (\(numberOfAttachments))")
                }
                cell.button.addTarget(self, action: #selector(attachments), for: .touchUpInside)
            }

            
            if formItem.title == "Tasks" {
                let numberOfTasks = getNumberOfTaskForProject()
                
                if numberOfTasks != 0 {
                  cell.setTitle(text: "Tasks (\(numberOfTasks))")
                }
                
                cell.button.addTarget(self, action: #selector(tasks), for: .touchUpInside)
            }
            
            return cell
            
        case .textView:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "textView", for: indexPath) as! TextViewButtonTableViewCell
            cell.setTextViewText(text: projectForVc.description)
            cell.button.addTarget(self, action: #selector(getter: description), for: .touchUpInside)
            
            return cell
            
        case .textField:
            return UITableViewCell()
            
        case .picker:
            return UITableViewCell()
            
      }
        
   }
    
    
}


extension ProjectVc1:DescriptionViewDelegate {
    func setText(text: String) {
        projectForVc.description = text
        table.reloadData()
    }
}
