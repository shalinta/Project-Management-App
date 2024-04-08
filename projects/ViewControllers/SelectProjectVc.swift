//
//  AllProjectsViewController.swift
//  projects
//
//  Created by chirayu-pt6280 on 06/02/23.
//

import UIKit

// delegate to be implemented by view using the viewController
protocol ProjectSelectionDelegate {
    
    func showSelectedProject(_ project: Project?)
    
}



class SelectProjectVc: UIViewController {

    
    //  list of all projects
    var allProjects = [Project]()
    
    var filteredProjects = [Project]()
    
    var selectedProject:Project?
    
    // delegates get updates about the selected project
    var selectionDelegate: ProjectSelectionDelegate?
    
    
    lazy var searchBar = {
        
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchTextField.placeholder = "Search Projects"
        searchBar.searchTextField.addDoneButtonOnInputView(true)
        searchBar.delegate = self
        
        return searchBar
        
    }()
    
    lazy var noProjectFoundLabel =  {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 21)
        label.text = "No Such Project Found!"
        label.isHidden = true
        
        return label
    }()
    
    
    lazy var noProjectView = {
        
        let view = EmptyView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.emptyListImageView.image = UIImage(systemName: "folder")
        view.boldMessage.text = "No Projects"
        view.lightMessage.text = "Add Projects to add new task"
        view.isHidden = true
        view.button.addTarget(self, action: #selector(addProject), for: .touchUpInside)
        
        return view
    }()

    lazy var  projectsListTableView = {
        
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.separatorInset = .zero
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        
        return tableView
        
    }()
    
    lazy var cancelBarButtonItem = {
        
        let barButton = UIBarButtonItem()
        barButton.image = UIImage(systemName: "multiply")
        barButton.target = self
        barButton.action = #selector(cancel)
        
        return barButton
    }()
    
    lazy var addBarButtonItem = {
        
        let barButton = UIBarButtonItem()
        barButton.image = UIImage(systemName: "plus")
        barButton.target = self
        barButton.action = #selector(addProject)
        
        return barButton
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select Project"
        navigationItem.setLeftBarButton(cancelBarButtonItem, animated: false)
        navigationItem.setRightBarButton(addBarButtonItem, animated: true)
        setupSearchBar()
        setupTableView()
        setUpEmptyProjectView()
      
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        allProjects = getAllProjects()
        
        if allProjects.isEmpty {
            noProjectView.isHidden = false
        }
        
        filteredProjects = allProjects
        scrollToSelected()
        setApperance()
    }
    
    
    
    
    func scrollToSelected() {
        
        guard let Sproject = selectedProject else {
            return
        }
        
        var row:Int?
        
        row = allProjects.firstIndex { project in
            project.id == Sproject.id
        }
        
        guard let unRow = row else {
            return
        }
        
        projectsListTableView.scrollToRow(at: IndexPath(row: unRow , section: 0), at: .top, animated: true)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setApperance()
    }
    
    
    func setUpEmptyProjectView() {
        
        view.addSubview(noProjectView)
        
        NSLayoutConstraint.activate([
            
            noProjectView.heightAnchor.constraint(equalToConstant:120),
            noProjectView.widthAnchor.constraint(equalToConstant:120),
            
            noProjectView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noProjectView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    
    func setupTableView() {
    
      projectsListTableView.addSubview(noProjectFoundLabel)
      view.addSubview(projectsListTableView)
        
        NSLayoutConstraint.activate ([
            
           projectsListTableView.topAnchor.constraint(equalTo:searchBar.bottomAnchor,constant: 20),
           projectsListTableView.widthAnchor.constraint(equalTo: view.widthAnchor),
           projectsListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -10),
           
           noProjectFoundLabel.centerXAnchor.constraint(equalTo: projectsListTableView.centerXAnchor),
           noProjectFoundLabel.centerYAnchor.constraint(equalTo: projectsListTableView.centerYAnchor,constant: -150)
        ])
    }
    
    
    func setupSearchBar() {
       
        view.addSubview(searchBar)
       
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 10),
            searchBar.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    
    func setApperance() {
        view.backgroundColor = currentTheme.backgroundColor
        searchBar.tintColor = currentTheme.tintColor
        projectsListTableView.separatorColor = currentTheme.tintColor
        noProjectFoundLabel.textColor = currentTheme.secondaryLabel.withAlphaComponent(0.6)
        navigationController?.navigationBar.tintColor = currentTheme.tintColor
        navigationController?.navigationBar.backgroundColor = currentTheme.secondaryLabel.withAlphaComponent(0.1)
        
    }
    
    @objc func cancel() {
        dismiss(animated: true)
    }
    
    func getAllProjects()->[Project] {
        
        var projects = [Project]()
        
        let output = DatabaseHelper.shared.selectFrom(table: ProjectTable.title,
                                                      columns: nil, wherec: nil)

       output.forEach { row in

           guard let id = row[ProjectTable.id] as? String,
                 let name = row[ProjectTable.name] as? String,
                 let startDate =  row[ProjectTable.startDate] as? Double,
                 let endDate = row[ProjectTable.endDate] as? Double,
                 let desc = row[ProjectTable.description] as? String,
                 let status = ProjectStatus(rawValue: (row[ProjectTable.status] as? String)!) else {

               print("cannot create a project at row \(row)")
               return
           }

           let project = Project(projectId: UUID(uuidString: id)!,
                                 projectName: name,
                                 startDate: Date(timeIntervalSince1970: startDate),
                                 endDate: Date(timeIntervalSince1970:endDate),
                                 description: desc,
                                 status: status)
           
        
           projects.append(project)
        }

        return projects
    }
    
    @objc func addProject() {
        
        let addProjectVc =  AddProjectVc()
        addProjectVc.delegate = self
        addProjectVc.modalPresentationStyle = .formSheet
        present(UINavigationController(rootViewController: addProjectVc), animated: true)
        
    }
}





extension SelectProjectVc:UITableViewDelegate,UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProjects.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.backgroundColor = currentTheme.backgroundColor
        
        if selectedProject?.id == filteredProjects[indexPath.row].id {
            cell?.backgroundColor = currentTheme.tintColor.withAlphaComponent(0.5)
        }
        
        cell?.textLabel?.setHighlighted(filteredProjects[indexPath.row].name, searchString: searchBar.text)
       
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedProject = filteredProjects[indexPath.row]
        selectionDelegate?.showSelectedProject(selectedProject)
        dismiss(animated: true)
        
    }
}

extension SelectProjectVc:UISearchBarDelegate {
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        noProjectFoundLabel.isHidden = true
        
        guard let text = searchBar.text , text.isEmpty == false else {
            filteredProjects = allProjects
            projectsListTableView.reloadData()
            return
        }
        
        filteredProjects = allProjects.filter { project in
            project.name.localizedCaseInsensitiveContains(text)
          }
        
        projectsListTableView.reloadData()
        
        if filteredProjects.isEmpty {
            print(#function)
            noProjectFoundLabel.isHidden = false
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.resignFirstResponder()
    }
    
}

extension SelectProjectVc:AddProjectDelegate {
  
    func update(project: Project) {
        filteredProjects = getAllProjects()
        projectsListTableView.reloadData()
        noProjectView.isHidden = true
    }
}
