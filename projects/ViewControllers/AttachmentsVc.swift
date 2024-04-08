//
//  AttachmentsViewController.swift
//  projects
//
//  Created by chirayu-pt6280 on 13/02/23.
//

import UIKit
import UniformTypeIdentifiers

enum AttachmentType:String,CaseIterable {
   
    case Pdf
    
    case Image

}

enum AttachmentsFor:String {
    
    case Tasks
    
    case Projects
}


enum PickerOption:String {
    
    case Files
    
    case Gallery
    
    case Camera
}



class AttachmentsVc: UIViewController {
    
    
    var attachments = [Attachment]()
    var attachmentsFor:AttachmentsFor
    var idForAttachments:UUID
    
    
init(id:UUID,attachmentsFor:AttachmentsFor) {
        
        self.idForAttachments = id
        self.attachmentsFor = attachmentsFor
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var attachmentsTableView = {
        
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AttachmentsTableViewCell.self, forCellReuseIdentifier: AttachmentsTableViewCell.identifier)
        tableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderView.identifier)
        
        return tableView
    }()
    
    
    lazy var importBarButton = {
       
        let barButton = UIBarButtonItem()
        barButton.title = "Import"
        barButton.image = UIImage(systemName: "paperclip")
        barButton.primaryAction = nil
        barButton.target = self
        barButton.action = #selector(addAttachments)
        
        return barButton
    }()
    
    lazy var noAttachmentsView = {
        
        let view = EmptyView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.emptyListImageView.image = UIImage(systemName: "paperclip")
        view.boldMessage.text = "No Attachments"
        view.lightMessage.text = "Press + to Add New To-Do"
        view.button.addTarget(self, action: #selector(addAttachments), for: .touchUpInside)
        view.isHidden = true
        
        return view
    }()
    
    func updateData() {
        
        attachments = getAttachments()
         
        noAttachmentsView.isHidden = !attachments.isEmpty
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        setupAttachmentsTableview()
        setupNavigationBar()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateData()
        attachmentsTableView.reloadData()
        
        setApperance()
        setupNoProjectView()
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setApperance()
    }
    
    
    func setApperance() {
        
        view.backgroundColor = currentTheme.backgroundColor
        noAttachmentsView.emptyListImageView.tintColor = currentTheme.tintColor
        navigationController?.navigationBar.tintColor  = currentTheme.tintColor
    }
    
    func setupNoProjectView() {
      
        view.addSubview(noAttachmentsView)
      
        
        NSLayoutConstraint.activate([
            
            noAttachmentsView.heightAnchor.constraint(equalToConstant:120),
            noAttachmentsView.widthAnchor.constraint(equalToConstant:150),
            
            noAttachmentsView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noAttachmentsView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupNavigationBar() {
        
        self.title = "Attachments"
        navigationItem.setRightBarButton(importBarButton, animated: true)
      
        
    }
    
    
    func setupAttachmentsTableview() {
        
        view.addSubview(attachmentsTableView)
        
        NSLayoutConstraint.activate([
            attachmentsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            attachmentsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            attachmentsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            attachmentsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    
    func getAttachments()->[Attachment] {
    
        var output = [Dictionary<String,Any>]()
        var attachments = [Attachment]()
        
        switch attachmentsFor {
            
        case .Tasks:
            
            output = DatabaseHelper.shared.selectFrom(table: AttachmentTable.taskAttachmentsTable, columns: nil, wherec: [AttachmentTable.associatedId:.text(idForAttachments.uuidString)])
            
        case .Projects:
            
            output =  DatabaseHelper.shared.selectFrom(table: AttachmentTable.projectAttachmentTable, columns: nil, wherec:  [AttachmentTable.associatedId:.text(idForAttachments.uuidString)])
            
        }
        
        output.forEach { rows in
            
            guard let id = rows[AttachmentTable.id] as? String,
                  let name = rows[AttachmentTable.name] as? String,
                  let path = rows[AttachmentTable.path] as? String,
                  let assocaitedId = rows[AttachmentTable.associatedId] as? String,
                  let type = rows[AttachmentTable.type] as? String
                    
            else {
            
                return
            }
            
          guard let attachmentType = AttachmentType(rawValue: type) else {
            
                return
            }
            
            guard let attachmentId = UUID(uuidString: id) else {
               
                return
            }
            
            guard let associatedId = UUID(uuidString: assocaitedId) else {
          
                return
            }
            
            guard let url = URL(string: path) else {
                
                return
            }
            
            let attachment = Attachment(id:attachmentId, itemId:associatedId, name: name, path: url, type: attachmentType)
            
            attachments.append(attachment)
        }
    
        return attachments
    }
    
    
    
    @objc func addAttachments() {
        
        let alert = UIAlertController(title:nil, message:nil, preferredStyle: .actionSheet)
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { _ in
                    
                }))
        
        alert.addAction(UIAlertAction(title: PickerOption.Files.rawValue, style: .default,handler: { _ in
            
            let  picker = UIDocumentPickerViewController(forOpeningContentTypes: [.image,.pdf],asCopy: true)
            picker.delegate = self
            picker.modalPresentationStyle = .formSheet
            self.present(picker, animated: true)
            
            
        }))
        
        alert.addAction(UIAlertAction(title: PickerOption.Gallery.rawValue, style: .default,handler: { _ in
            
            let  picker = UIImagePickerController()
            picker.delegate = self
            picker.mediaTypes = ["public.image"]
            picker.modalPresentationStyle = .formSheet
            self.present(picker, animated: true)
            
            
        }))
        
        alert.addAction(UIAlertAction(title: PickerOption.Camera.rawValue, style: .default,handler: {_ in
           
            let  picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera
            picker.modalPresentationStyle = .formSheet
            self.present(picker, animated: true)
            
            
        }))
        
       present(alert, animated: true)
        
    }
}


extension AttachmentsVc: UITableViewDataSource,UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
       attachments.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let attachment = attachments[indexPath.row]
      
        let cell = tableView.dequeueReusableCell(withIdentifier: AttachmentsTableViewCell.identifier) as! AttachmentsTableViewCell
        cell.configure(for: attachment)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title: "Delete", handler: { [self]
             (action,source,completion) in
            
            let attachment = attachments[indexPath.row]
            
           try? FileManager.default.removeItem(at: attachment.path)
            
            switch attachmentsFor {
            
            case .Projects:
                
                DatabaseHelper.shared.deleteFrom(tableName: AttachmentTable.projectAttachmentTable, whereC:
                                                    [AttachmentTable.id:.text(attachment.id.uuidString)])
            case .Tasks:
                
                DatabaseHelper.shared.deleteFrom(tableName: AttachmentTable.taskAttachmentsTable, whereC:
                                                    [AttachmentTable.id:.text(attachment.id.uuidString)])
            }
            
           
          
            updateData()
            self.attachmentsTableView.reloadData()
            
            completion(true)
            
        })
        
        deleteAction.backgroundColor  = .systemRed
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = true
        
        return config
    }
        
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let attachment = attachments[indexPath.row]
      
        let documentViewer = UIDocumentInteractionController(url: attachment.path)
        documentViewer.delegate = self
        documentViewer.presentPreview(animated: true)
        
    }
}

extension AttachmentsVc: UIDocumentPickerDelegate {
  
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard let url = urls.first else {
            return
        }
        
        var type:AttachmentType
        
        if url.lastPathComponent.hasSuffix("pdf") {
            type = .Pdf
        } else {
            type = .Image
        }
       
       let attachment = Attachment(itemId: idForAttachments, name: url.lastPathComponent, path: url,type: type)
        
      
        switch attachmentsFor {
            
        case .Projects:
            
            DatabaseHelper.shared.insertInto(table: AttachmentTable.projectAttachmentTable,
                                    values: [AttachmentTable.id:.text(attachment.id.uuidString),
                                                      AttachmentTable.name:.text(attachment.name),
                                                      AttachmentTable.path:.text(attachment.path.absoluteString),
                                                      AttachmentTable.associatedId:.text(idForAttachments.uuidString),
                                                      AttachmentTable.type:.text(attachment.type.rawValue)])
            
        case .Tasks:
            
            
            DatabaseHelper.shared.insertInto(table: AttachmentTable.taskAttachmentsTable,
                                    values: [AttachmentTable.id:.text(attachment.id.uuidString),
                                                      AttachmentTable.name:.text(attachment.name),
                                                      AttachmentTable.path:.text(attachment.path.absoluteString),
                                                      AttachmentTable.associatedId:.text(idForAttachments.uuidString),
                                                      AttachmentTable.type:.text(attachment.type.rawValue)])
        }
        
       updateData()
       attachmentsTableView.reloadData()
    }
}

extension AttachmentsVc:UIDocumentInteractionControllerDelegate {
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        
           return self
       }
}


extension AttachmentsVc:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
     
       
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
      
        
        guard let image = info[.originalImage] as? UIImage else {
                    print("No image found")
                    return
                }
        
        
        let imageId = UUID()
        let imageName = "\(imageId.uuidString.prefix(10)).jpeg"
        let imagePath = paths.appendingPathComponent(imageName)

        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
                    print("Image Save to path \(imagePath)")
                    try? jpegData.write(to: imagePath)
                }
        
        let attachment = Attachment(id: imageId, itemId: idForAttachments, name: imageName, path: imagePath, type: .Image)
        
        switch attachmentsFor {
            
        case .Projects:
            
            DatabaseHelper.shared.insertInto(table: AttachmentTable.projectAttachmentTable,
                                    values: [AttachmentTable.id:.text(attachment.id.uuidString),
                                                      AttachmentTable.name:.text(attachment.name),
                                                      AttachmentTable.path:.text(attachment.path.absoluteString),
                                                      AttachmentTable.associatedId:.text(idForAttachments.uuidString),
                                                      AttachmentTable.type:.text(attachment.type.rawValue)])
            
        case .Tasks:
            
            
            DatabaseHelper.shared.insertInto(table: AttachmentTable.taskAttachmentsTable,
                                    values: [AttachmentTable.id:.text(attachment.id.uuidString),
                                                      AttachmentTable.name:.text(attachment.name),
                                                      AttachmentTable.path:.text(attachment.path.absoluteString),
                                                      AttachmentTable.associatedId:.text(idForAttachments.uuidString),
                                                      AttachmentTable.type:.text(attachment.type.rawValue)])
        }

        updateData()
        attachmentsTableView.reloadData()
        dismiss(animated: true)
       
        
    }
    
}
