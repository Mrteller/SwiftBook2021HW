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
    private var taskList: [Task] = []
    private var indexPathForSelectedRow: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "LabelMainColor")
        // Add blur to UIAlertController (no effect if we use color)
        // UIVisualEffectView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).effect = UIBlurEffect(style: .extraLight)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavigationBar()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
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
        
        navigationController?.navigationBar.tintColor = .white
        
    }
    
    @objc private func addNewTask() {
        showAlert(with: "New Task", and: "What do you want to do?", rowAction: .add)
    }
    
    private func fetchData() {
        let fetchRequest = Task.fetchRequest()
        
        do {
            taskList = try context.fetch(fetchRequest)
        } catch {
           print("Faild to fetch data", error)
        }
    }
    
    private func showAlert(with title: String, and message: String, rowAction: RowAction) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction: UIAlertAction
        switch rowAction {
        case .add:
            saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
                guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
                self?.append(task)
            }
        case .edit:
            saveAction = UIAlertAction(title: "Confirm", style: .default) { [weak self] _ in
                guard let task = alert.textFields?.first?.text, !task.isEmpty, let indexPath = self?.indexPathForSelectedRow else { return }
                self?.edit(at: indexPath, task)
            }
        case .delete:
            saveAction = UIAlertAction(title: "Delete", style: .default) { [weak self] _ in
                guard let indexPath = self?.indexPathForSelectedRow else { return }
                self?.delete(at: indexPath)
            }
        }

        saveAction.setValue(UIColor(named: "LabelMainColor") ?? .white, forKey: "titleTextColor")

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)

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
                string: alert.title!,
                attributes: [.foregroundColor : UIColor(named: "LabelMainColor") ?? .white])
            alert.setValue(titleAttributed, forKey: "attributedTitle")
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
        
    private func append(_ taskName: String) {
        
        let task = Task(context: context)
        task.name = taskName
        taskList.append(task)
        
        let cellIndex = IndexPath(row: taskList.count - 1, section: 0)
        tableView.insertRows(at: [cellIndex], with: .automatic)
        
        StorageManager.shared.saveContext()
    }
    
    private func edit(at indexPath: IndexPath, _ taskName: String) {
        
        let task = taskList[indexPath.row]
        task.name = taskName
        taskList[indexPath.row] = task
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        StorageManager.shared.saveContext()
    }
    
    private func delete(at indexPath: IndexPath) {
        
        let task = taskList[indexPath.row]
        context.delete(task)
        
        taskList.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        StorageManager.shared.saveContext()
    }
}

extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = taskList[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = task.name
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        indexPathForSelectedRow = indexPath
        let delete = UIContextualAction(style: .destructive, title: "") { [weak self] (action, view, completion) in
            print("Delete Pressed", action)
            self?.showAlert(with: "Delete task", and: "Are you sure?", rowAction: .delete)

        }
        delete.backgroundColor = .systemGreen
        delete.image = UIImage(systemName: "trash")
  
        
        let edit = UIContextualAction(style: .normal, title: "") { [weak self] (action, view, completion) in
            print("Edit Pressed", action)
            self?.showAlert(with: "Edit task", and: "Enter new description", rowAction: .edit)
        }
        edit.backgroundColor = .systemRed
        edit.image = UIImage(systemName: "doc.badge.gearshape")
        
        let config = UISwipeActionsConfiguration(actions: [delete, edit])
        config.performsFirstActionWithFullSwipe = false
        
        return config
    }
}
