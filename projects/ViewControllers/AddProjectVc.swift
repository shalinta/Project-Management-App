//
//  AddProjectVc.swift
//  projects
//
//  Created by chirayu-pt6280 on 03/03/23.
//

import UIKit


enum AddProjectFormSection:String {
    
    case Name
    
    case StartDate
    
    case EndDate
    
    case Status
    
    case Description
}


protocol AddProjectDelegate {
    func update(project: Project)
}

struct AddProjectForm {
    
    var name:String?
    var startDate:Date = Date()
    var endDate:Date = Date()
    var status:ProjectStatus?
    var description:String?
    
}

class AddProjectVc: UIViewController {
    
    
    var delegate:AddProjectDelegate?
    let statusArray = ProjectStatus.allCases.map({$0.rawValue})
    var addProjectForm = AddProjectForm()
    var savePressed = false
    
    let form:[TableViewSection] = [
        
        TableViewSection(title: AddProjectFormSection.Name.rawValue, fields:
              [TableViewField(title: "Project Name",type: .textField)]),
        
        TableViewSection(title: AddProjectFormSection.Status.rawValue, fields:
              [TableViewField(title: "Status",type: .picker)]),
        
        TableViewSection(title: AddProjectFormSection.StartDate.rawValue, fields:
              [TableViewField(title: "Start Date", image:UIImage(systemName: "calendar") , type:.datePicker)]),
        
        TableViewSection(title: AddProjectFormSection.EndDate.rawValue, fields:
                [TableViewField(title: "End Date", image:UIImage(systemName: "calendar") , type:.datePicker)]),
        
        TableViewSection(title: AddProjectFormSection.Description.rawValue, fields:
              [TableViewField(title: "Description",type: .textView)])
    ]
    
    

    
    lazy var addProjectTableView = {
        
        let tableView =  UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TextViewButtonTableViewCell.self, forCellReuseIdentifier: TextViewButtonTableViewCell.identifier)
        tableView.register(TextFieldTableViewCell.self,forCellReuseIdentifier: TextFieldTableViewCell.identifier)
        tableView.register(ButtonTableViewCell.self, forCellReuseIdentifier: ButtonTableViewCell.identifier)
        tableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderView.identifier)
        tableView.separatorColor = .clear
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        additionalSafeAreaInsets = UIEdgeInsets(top: 5, left: 20, bottom: 0, right: 20)
        setupNavigationBar()
        view.addSubview(addProjectTableView)
        setTableViewConstraint()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setApperance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentationController?.delegate = self
        
        setApperance()
    }
    
    func setupNavigationBar() {
        self.title = "Add Project"
        navigationItem.setLeftBarButton(cancelBarButton, animated: true)
        navigationItem.setRightBarButton(saveBarButton, animated: true)
    }
    
    func setApperance() {
        view.backgroundColor = currentTheme.backgroundColor
        navigationController?.navigationBar.backgroundColor  = currentTheme.secondaryLabel.withAlphaComponent(0.1)
        self.navigationController?.navigationBar.tintColor = currentTheme.tintColor
    }
    
    
    func setTableViewConstraint() {
        
        let keyBoardLayoutGuide = addProjectTableView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
        keyBoardLayoutGuide.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            addProjectTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant:0),
            addProjectTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            addProjectTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            keyBoardLayoutGuide
        ])
        
    }
    
    func showDismissAlert() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { _ in
            
        }))
        
        alert.addAction(UIAlertAction(title: "Discard Changes", style: .destructive,handler: { _ in
            self.dismiss(animated: true)
        }))
        
        if addProjectForm.status == nil,
           addProjectForm.name == nil || addProjectForm.name?.isEmpty == true {
               dismiss(animated: true)
           } else {
               present(alert, animated: true)
           }
    }
    
    @objc func save() {
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        
        savePressed = true
        addProjectTableView.reloadData()
        
       
        
        guard let unProjectname = addProjectForm.name,
              unProjectname.trimmingCharacters(in: .whitespaces).isEmpty == false,
              unProjectname.count < 120,
              let unStatus = addProjectForm.status
                
            else {
            
            generator.impactOccurred()
            showToast(message: "Enter all the Required Details", seconds: 5)
            return
            
           }

        
        let project = Project(projectName: unProjectname, startDate: addProjectForm.startDate, endDate: addProjectForm.endDate, description: addProjectForm.description ?? "", status: unStatus)
       
        DatabaseHelper.shared.insertInto(table: ProjectTable.title,
                                         values:   [ProjectTable.id: .text(project.id.uuidString),
                                                   ProjectTable.name: .text(project.name),
                                                   ProjectTable.startDate: .double(project.startDate.timeIntervalSince1970),
                                                   ProjectTable.endDate: .double(project.endDate.timeIntervalSince1970),
                                                   ProjectTable.description: .text(project.description),
                                                   ProjectTable.status: .text(project.status.rawValue)])
    
        delegate?.update(project: project)
        dismiss(animated: true)
    }
    
    @objc func cancel() {
        showDismissAlert()
    }
    
    
    @objc func description() {
        
       let descriptionVc = DescriptionVc(text: addProjectForm.description ?? "")
        descriptionVc.delegate = self
        
        navigationController?.pushViewController(descriptionVc, animated: true)
        
    }
    
}


extension AddProjectVc:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let title = form[section].title
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! SectionHeaderView
        view.setupCell(text: title,fontSize: 18)
        
        return view
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
         nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return form.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        form[section].fields.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if form[indexPath.section].title == AddProjectFormSection.Description.rawValue {
            return 100
        }
        
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print(#function)
        
        let formItem = form[indexPath.section].fields[indexPath.row]
        
        switch formItem.type {
            
        case .button:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "button") as!ButtonTableViewCell
            cell.configure(forItem: formItem)
            
            return cell
            
        case .picker:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "textField") as! TextFieldTableViewCell
            cell.pickerViewData = statusArray
            cell.configure(forItem: formItem)
            cell.setText(text: addProjectForm.status?.rawValue)
           
            cell.textChanged = {  text in
                guard let unWrappedText = text,unWrappedText.isEmpty == false else {
                    return
                }
                
                self.addProjectForm.status = ProjectStatus(rawValue: unWrappedText) ?? ProjectStatus.Active
                
            }
            
            if savePressed {
                if addProjectForm.status != nil {
                    cell.hideValidationMessage()
                } else {
                    cell.showValidationMessage(msg: "Please select a Status for the Project")
                }
                
            }
            
            return cell
            
        case .datePicker:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "textField") as! TextFieldTableViewCell
          
          
            if formItem.title == "Start Date" {
                
                cell.selectedDate = self.addProjectForm.startDate
                cell.configure(forItem: formItem)
                cell.textChanged = { _ in
                    self.addProjectForm.startDate = cell.selectedDate
                }
                
                
            }
            
            if formItem.title == "End Date" {
                
                cell.selectedDate = self.addProjectForm.endDate
                cell.configure(forItem: formItem)
                cell.textChanged = { _ in
                    self.addProjectForm.endDate = cell.selectedDate
                }
                
            }
            
            
            
            return cell
            
        case .textField:
            let cell = tableView.dequeueReusableCell(withIdentifier: "textField") as! TextFieldTableViewCell
            cell.configure(forItem: formItem)
            cell.setText(text: addProjectForm.name)
            
            if formItem.title == "Project Name" {
                cell.textChanged =  { text in
                    self.addProjectForm.name = text
                }
                
                if savePressed {
                    
                    if let name = addProjectForm.name,name.trimmingCharacters(in: .whitespaces).isEmpty == false {
                        if name.count > 120 {
                            cell.showValidationMessage(msg: "Project name can only be 120 characters")
                        } else {
                            cell.hideValidationMessage()
                        }
                    } else {
                        cell.showValidationMessage(msg: "Enter a name for the Project")
                    }
                }
                
            }
            
            return cell
   
        case .textView:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TextViewButtonTableViewCell.identifier) as! TextViewButtonTableViewCell
            cell.textView.text = addProjectForm.description
            cell.button.addTarget(self, action: #selector(getter: description), for: .touchUpInside)
            
            return cell

        }
        
    }
    
    
    
}


extension AddProjectVc:DescriptionViewDelegate {
    
    func setText(text: String) {
        addProjectForm.description = text
        addProjectTableView.reloadData()
    }
    
    
}

extension AddProjectVc:UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        false
    }
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        showDismissAlert()
    }
    
}
