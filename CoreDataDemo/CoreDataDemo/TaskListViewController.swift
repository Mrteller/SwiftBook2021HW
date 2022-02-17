//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by brubru on 24.01.2022.
//

import UIKit

class TaskListViewController: UITableViewController {
    
    enum RowAction {
        case add, edit, delete
    }
    
    private let context = StorageManager.shared.persistentContainer.viewContext
    private let cellID = "task"

    private var indexPathForSelectedRow: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "LabelMainColor")
        // Add blur to UIAlertController (no effect if we use color)
        // UIVisualEffectView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).effect = UIBlurEffect(style: .extraLight)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        StorageManager.shared.fetchData()
        tableView.reloadData()
    }
 
    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearence = UINavigationBarAppearance()
        navBarAppearence.configureWithOpaqueBackground()
        navBarAppearence.titleTextAttributes = [.foregroundColor: UIColor(named: "LabelMainColor") ?? .white]
        navBarAppearence.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "LabelMainColor") ?? .white]
        
        navBarAppearence.backgroundColor = UIColor(named: "ThemeColor")
//        UIColor(
//            red: 21/255,
//            green: 101/255,
//            blue: 192/255,
//            alpha: 194/255
//        )
        
        navigationController?.navigationBar.standardAppearance = navBarAppearence
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearence
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        
        navigationItem.leftBarButtonItem = editButtonItem
//        UIBarButtonItem(
//            barButtonSystemItem: .edit,
//            target: self,
//            action: #selector(editTableViewToggle)
//        )
        
        navigationController?.navigationBar.tintColor = .white
        
    }
    
    @objc private func addNewTask() {
        showAlert(with: "New Task", and: "What do you want to do?", rowAction: .add)
    }
    
//    @objc private func editTableViewToggle() {
//        tableView.setEditing(!tableView.isEditing, animated: true)
//    }
    
    private func showAlert(with title: String, and message: String, rowAction: RowAction) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction: UIAlertAction
        switch rowAction {
        case .add:
            saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
                guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
                self?.appendTask(task)
            }
        case .edit:
            saveAction = UIAlertAction(title: "Confirm", style: .default) { [weak self] _ in
                guard let task = alert.textFields?.first?.text, !task.isEmpty, let indexPath = self?.indexPathForSelectedRow else { return }
                self?.editTask(at: indexPath, task)
            }
        case .delete:
            saveAction = UIAlertAction(title: "Delete", style: .default) { [weak self] _ in
                guard let indexPath = self?.indexPathForSelectedRow else { return }
                self?.deleteTask(at: indexPath)
            }
        }

        saveAction.setValue(UIColor(named: "LabelMainColor") ?? .white, forKey: "titleTextColor")
        saveAction.setValue(UIImage(systemName: "checkmark"), forKey: "image")

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        cancelAction.setValue(UIColor.systemOrange, forKey: "titleTextColor")
        cancelAction.setValue(UIImage(systemName: "xmark"), forKey: "image")
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        if rowAction != .delete {
            alert.addTextField { textField in
                textField.placeholder = "New Task"
            }
        }
        // It should respond but it does not. Yet setting the value works.
        // if alert.responds(to: Selector(("attributedTitle"))) {
        let titleAttributed = NSMutableAttributedString(
            string: "\n" + (alert.title ?? ""),
            attributes: [.foregroundColor : UIColor(named: "LabelMainColor") ?? .white])
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = UIImage(systemName: "rectangle.and.pencil.and.ellipsis")?.withTintColor(.systemOrange, renderingMode: .alwaysTemplate)
        // image1Attachment.bounds = CGRect(x: 0, y: 0, width: 80, height: 80)
        let titleAttributedWithImage = NSMutableAttributedString(attachment: image1Attachment)
        titleAttributedWithImage.append(titleAttributed)
        alert.setValue(titleAttributedWithImage, forKey: "attributedTitle")
        // }
        // Could not make it work safe way
        // let kp: ReferenceWritableKeyPath<UIAlertController, NSMutableAttributedString> = \.attributedTitle
        // alert[keyPath: kp] = titleAttributed
        let messageAttributed = NSMutableAttributedString(
            string: alert.message!,
            attributes: [.foregroundColor : UIColor(named: "LabelMainColor") ?? .white])
        alert.setValue(messageAttributed, forKey: "attributedMessage")
        
        if let subview = alert.view.subviews.first?.subviews.first?.subviews.first {
            subview.backgroundColor = UIColor(named: "ThemeColor")
            print(subview.tag)
        }
        // An alternative way of setting button color
        //alert.view.tintColor = UIColor(named: "LabelMainColor")

        present(alert, animated: true)
    }
        
    private func appendTask(_ taskName: String) {
        StorageManager.shared.appendTask(taskName)
        let cellIndex = IndexPath(row: StorageManager.shared.taskList.count - 1, section: 0)
        tableView.insertRows(at: [cellIndex], with: .automatic)
    }
    
    private func editTask(at indexPath: IndexPath, _ taskName: String) {
        StorageManager.shared.editTask(at: indexPath, taskName)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    private func deleteTask(at indexPath: IndexPath) {
        StorageManager.shared.deleteTask(at: indexPath)
// Does not work
        UIView.animate(withDuration: 10, delay: 0.0, options: .curveEaseInOut) { [weak self] in
            //self?.tableView.beginUpdates()
            //self?.tableView.deleteRows(at: [indexPath], with: .automatic)
            self?.tableView.reloadData()
            //self?.tableView.endUpdates()
        }
//        UIView.beginAnimations("animation", context: nil)
//        UIView.setAnimationDuration(6)
//        CATransaction.begin()
//        CATransaction.setCompletionBlock({
//            // completion block
//        })
//
//        tableView.beginUpdates()
//        tableView.deleteRows(at: [indexPath], with: .automatic)
//        tableView.endUpdates()
//
//        CATransaction.commit()
//        UIView.commitAnimations()
        
 //       tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        StorageManager.shared.taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = StorageManager.shared.taskList[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = task.name
        cell.contentConfiguration = content
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        indexPathForSelectedRow = indexPath
//        let delete = UIContextualAction(style: .destructive, title: "") { [weak self] (action, view, completion) in
//            // print("Delete Pressed", action)
//            self?.showAlert(with: "Delete task", and: "Are you sure?", rowAction: .delete)
//            completion(true)
//        }
//        delete.backgroundColor = .systemRed
//        delete.image = UIImage(systemName: "trash")
//
//
//        let edit = UIContextualAction(style: .normal, title: "") { [weak self] (action, view, completion) in
//            print("Edit Pressed", action)
//            self?.showAlert(with: "Edit task", and: "Enter new description", rowAction: .edit)
//            completion(true)
//        }
//        edit.backgroundColor = .systemGreen
//        edit.image = UIImage(systemName: "doc.badge.gearshape")
//
//        let config = UISwipeActionsConfiguration(actions: [delete, edit])
//        config.performsFirstActionWithFullSwipe = false
//
//        return config
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            deleteTask(at: indexPath)
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        "Delete"
    }

}
