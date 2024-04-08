//
//  ListOfCheckListViewController.swift
//  projects
//
//  Created by chirayu-pt6280 on 14/02/23.
//

import UIKit

class CheckListToDoVc: UIViewController {
    
    
    var checkListItems = [ToDoItem]()
    let task:Task
 

    init(task: Task) {
        self.task = task
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var addBarButtonItem = {
        
        let barButton = UIBarButtonItem()
        barButton.image = UIImage(systemName: "plus")
        barButton.target = self
        barButton.action = #selector(addToDoItem)
        
        return barButton
        
    }()
    
    lazy var noCheckListView = {
        
        let image = EmptyView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.emptyListImageView.image = UIImage(systemName: "checklist")
        image.boldMessage.text = "Nothing to Do"
        image.lightMessage.text = "Press + to Add New To-Do"
        image.isHidden = true
        
        return image
    }()

    
    lazy var checkListListTableView = {
        
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ToDoTableViewCell.self, forCellReuseIdentifier: "toDo")
        tableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "header")
        tableView.separatorInset = .zero
 
        return tableView
    
}()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "To-Do"
        additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        navigationItem.setRightBarButton(addBarButtonItem, animated: true)
        setupChecklistTableview()
        setupNoProjectView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTasks()
        setApperance()
        if checkListItems.isEmpty {
            insertEmptyToDoItem()
        }
    }
    

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setApperance()
    }
    
    
    func setupChecklistTableview() {
        view.addSubview(checkListListTableView)
        tableViewConstraints()
    }
    

    
    
    func updateTasks() {
        checkListItems = getCheckListForTask()
        noCheckListView.isHidden = !checkListItems.isEmpty
    }
    
    
    
    func setApperance() {
        view.backgroundColor = currentTheme.backgroundColor
        noCheckListView.emptyListImageView.tintColor = currentTheme.tintColor
        navigationController?.navigationBar.tintColor = currentTheme.tintColor
    }
    
    
    func setupNoProjectView() {
      
        view.addSubview(noCheckListView)
        
        
        NSLayoutConstraint.activate([
            
            noCheckListView.heightAnchor.constraint(equalToConstant:120),
            noCheckListView.widthAnchor.constraint(equalToConstant:120),
            
            noCheckListView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noCheckListView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    
    override func viewWillDisappear(_ animated: Bool) {
      
        checkListItems.forEach { toDoItem in
         
            guard toDoItem.toDo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false else {
                return
            }
            
            DatabaseHelper.shared.insertInto(table: ToDoTable.title,
                                             values: [ToDoTable.id:.text(toDoItem.Id.uuidString),
                                                      ToDoTable.task:.text(toDoItem.toDo),
                                                      ToDoTable.taskId:.text(task.id.uuidString),
                                                      ToDoTable.isComplete:.integer(Int64(toDoItem.isComplete.intValue))])
        }
    }
    
    func tableViewConstraints() {
        NSLayoutConstraint.activate([
            checkListListTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 10),
            checkListListTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            checkListListTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            checkListListTableView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor,constant: -20)
        ])
    }
    
    func getCheckListForTask()->[ToDoItem] {
        
        
        let output = DatabaseHelper.shared.selectFrom(table: ToDoTable.title, columns: nil, wherec:
                                                        [ToDoTable.taskId:.text(task.id.uuidString)])
        
        var toDolist = [ToDoItem]()
        
        output.forEach { row in
            
            guard let id = row[ToDoTable.id] as? String,
                  let desc = row[ToDoTable.task] as? String,
                  let isComplete = row[ToDoTable.isComplete] as? Int else {
            
                return
            }
            
            guard let itemId = UUID(uuidString: id) else {
              
                return
            }
            
            let toDoItem = ToDoItem(taskId: task.id,
                                    Id: itemId, task: desc,
                                    isComplete: isComplete.boolValue)
            
            toDolist.append(toDoItem)
        }

        print(toDolist)
        return toDolist
    }
    
    func insertEmptyToDoItem() {
        
        let toDoItem = ToDoItem(taskId: task.id, task: "", isComplete: false)
        
        checkListItems.append(toDoItem)
        checkListListTableView.reloadData()
        
        noCheckListView.isHidden = !checkListItems.isEmpty
        
        print("----------------------")
        print(checkListItems.count)
    }
    
    
   @objc func addToDoItem() {
              
       guard checkListItems.last!.toDo.trimmingCharacters(in:.whitespacesAndNewlines).isEmpty == false  else {
           showToast(message: "To Do item cannot be Empty ", seconds: 2)
           print(checkListItems.count)
           return
       }
       view.endEditing(true)
       insertEmptyToDoItem()
    }
    
}


extension CheckListToDoVc:UITableViewDataSource,UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(checkListItems.count)
        print(#function)
        return checkListItems.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Checklists"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDo") as! ToDoTableViewCell

        
        let toDoItem = checkListItems[indexPath.row]
        
      
        
        cell.setupItem(toDo: toDoItem)
        
        cell.checkBoxHandler =  { isChecked in
            
            self.checkListItems[indexPath.row].isComplete = isChecked
            
         }
        
        
       cell.textChanged = { [self] textViewText in
            
           checkListItems[indexPath.row].toDo = textViewText
            
            self.checkListListTableView.beginUpdates()
            self.checkListListTableView.endUpdates()
        }
        
        
        if toDoItem.Id == self.checkListItems.last?.Id {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                cell.textView.becomeFirstResponder()
            })
        }
        
       return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { [self]
             (action,source,completion) in
            
            let toDoItem = checkListItems[indexPath.row]
            
            checkListItems.remove(at: indexPath.row)
            
            DatabaseHelper.shared.deleteFrom(tableName: ToDoTable.title, whereC:
                                                [ToDoTable.id:.text(toDoItem.Id.uuidString)])
            
             checkListListTableView.reloadData()
             noCheckListView.isHidden = !checkListItems.isEmpty
            
            completion(true)
        })
        
        deleteAction.backgroundColor  = .systemRed
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = true
        
        return config
        
    }
    
}
