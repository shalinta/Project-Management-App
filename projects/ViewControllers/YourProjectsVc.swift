//
//  YourProjectsViewController.swift
//  projects
//
//  Created by chirayu-pt6280 on 03/02/23.
//

import UIKit


enum ProjectStatus:String,CaseIterable {
  
    case Active
    
    case OnHold = "On Hold"
    
    case Planning
    
    case Delayed
}

struct ProjectViewSection {
    
    var title:String
    
    var projects:[Project]
    
}


class YourProjectsVc: UIViewController {
    
    
    var projectSections = [ProjectViewSection]()
    
    
    lazy var projectsTableView = {
        
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(ProjectTableViewCell.self, forCellReuseIdentifier: ProjectTableViewCell.identifier)
        table.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderView.identifier)
       
        
        return table
        
    }()
    

    lazy var addProjectBarButton = {
        
        let barButton = UIBarButtonItem()
        barButton.image = UIImage(systemName: "plus")
        barButton.target = self
        barButton.action = #selector(self.addProject)
        
        return barButton
    }()
    
    
    lazy var noProjectView = {
        
        let view = EmptyView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.emptyListImageView.image = UIImage(systemName: "folder")
        view.boldMessage.text = "No Projects"
        view.lightMessage.text = "Press + to Add New Project"
        view.isHidden = true
        view.button.addTarget(self, action: #selector(addProject), for: .touchUpInside)
        
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.keyboardLayoutGuide.followsUndockedKeyboard = true
        
        updateData()
        setupNavigationBar()
        setupTableView()
        setupNoProjectView()
        
    }
    
    
    func updateData() {
        
        projectSections.removeAll()
        
        getAllProjects().forEach({ (key: ProjectStatus, value: [Project]) in
            projectSections.append(ProjectViewSection(title: key.rawValue, projects: value))
        })
        
       projectSections =  projectSections.sorted {$0.title < $1.title}
        
        noProjectView.isHidden = !projectSections.isEmpty
        
    }
    

    func setupNoProjectView() {
      
        view.addSubview(noProjectView)
        
        
        NSLayoutConstraint.activate([
            
            noProjectView.heightAnchor.constraint(equalToConstant:120),
            noProjectView.widthAnchor.constraint(equalToConstant:120),
            
            noProjectView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noProjectView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupTableView() {
        
        view.addSubview(projectsTableView)
        
        NSLayoutConstraint.activate([
            projectsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            projectsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            projectsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            projectsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    
    func setupNavigationBar() {
        self.title = "Projects"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.setRightBarButton(addProjectBarButton, animated: true)
        navigationItem.largeTitleDisplayMode = .always
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        updateData()
        projectsTableView.reloadData()
        setAppearance()
        setupNavigationBar()
    }

    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
     
        projectsTableView.reloadData()
        setAppearance()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    
    }
    
    func setAppearance() {
        view.backgroundColor = currentTheme.backgroundColor
        noProjectView.emptyListImageView.tintColor = currentTheme.tintColor
        navigationController?.navigationBar.tintColor = currentTheme.tintColor
    }
    
    
    
    func getAllProjects()->[ProjectStatus:[Project]] {

        var projects = [ProjectStatus:[Project]]()
        let output = DatabaseHelper.shared.selectFrom( table: ProjectTable.title,
                                                       columns: nil,
                                                       wherec: nil )

       output.forEach { row in

           guard let id  =  row[ProjectTable.id] as? String,
                 let name =  row[ProjectTable.name] as? String,
                 let startDate = row[ProjectTable.startDate] as? Double,
                 let endDate = row[ProjectTable.endDate] as? Double,
                 let desc = row[ProjectTable.description] as? String,
                 let status = ProjectStatus(rawValue: (row[ProjectTable.status] as? String)!)
           else {
               print("cannot create a project at row \(row)")
               return
            }
           
           guard let pid = UUID(uuidString: id) else {
               return
           }

           
           let project = Project(projectId: pid,
                                 projectName: name,
                                 startDate: Date(timeIntervalSince1970: startDate),
                                 endDate: Date(timeIntervalSince1970:endDate),
                                 description: desc,
                                 status: status)
           
           
           if  projects[project.status] != nil {
               projects[project.status]!.append(project)
           } else {
               projects[project.status] = [project]
           }
        }
        

        return projects
    }
    
    func getAllAttachmentsPaths(project:Project)->[URL] {
        
        var output = [Dictionary<String,Any>]()
        var attachments = [URL]()
        
        output = DatabaseHelper.shared.selectFrom(table: AttachmentTable.projectAttachmentTable, columns: [AttachmentTable.path], wherec: [AttachmentTable.associatedId:.text(project.id.uuidString)])
        
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
  

    @objc func addProject() {
        
        let addProjectVc =  AddProjectVc()
        addProjectVc.delegate = self
        addProjectVc.modalPresentationStyle = .formSheet
        present(UINavigationController(rootViewController: addProjectVc), animated: true)
        
    }

}


extension YourProjectsVc:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return projectSections.count
    }


    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
   
        let text = projectSections[section].title
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderView.identifier) as! SectionHeaderView
        view.setupCell(text: text,fontSize: 21)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(#function)
    
        return projectSections[section].projects.count
    }
 
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title: "Delete", handler: { [self]
             (action,source,completion) in
            
            let project = projectSections[indexPath.section].projects[indexPath.row]
            
            getAllAttachmentsPaths(project: project).forEach { url in
                
                try? FileManager.default.removeItem(at: url)
            }
            
            DatabaseHelper.shared.deleteFrom(tableName: ProjectTable.title,
                                             whereC:[ProjectTable.id:.text(project.id.uuidString)])
           
            updateData()
            self.projectsTableView.reloadData()
            
            completion(true)
            
        })
        
        deleteAction.backgroundColor  = .systemRed
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = true
        
        return config
        
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: ProjectTableViewCell.identifier) as! ProjectTableViewCell
        
        let project = projectSections[indexPath.section].projects[indexPath.row]

        
        cell.setDetails(project:project)

        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       let project = projectSections[indexPath.section].projects[indexPath.row]
        
        let projectVc = ProjectVc1(projectForVc: project)
        
        navigationController?.pushViewController(projectVc, animated: true)
    }
    
    
}


extension YourProjectsVc:AddProjectDelegate {
    
    func update(project: Project) {
        updateData()
        projectsTableView.reloadData()
        showToast(message: "--\(project.name)-- added successfully", seconds: 5)
    }
    
}
