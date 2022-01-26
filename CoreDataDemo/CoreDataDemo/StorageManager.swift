//
//  StorageManager.swift
//  CoreDataDemo
//
//  Created by  Paul on 25.01.2022.
//

import Foundation
import CoreData

final class StorageManager {
    
    // MARK: - Public vars
    
    static var shared = StorageManager()
    
    lazy private(set) var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy private(set) var context = persistentContainer.viewContext
    
    var taskList: [Task] = []
    
    // MARK: - Initializers
    
    private init() { }
    
    // MARK: - Public funcs
    
    func fetchData() {
        let fetchRequest = Task.fetchRequest()
        
        do {
            taskList = try context.fetch(fetchRequest)
        } catch {
           print("Faild to fetch data", error)
        }
    }
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func appendTask(_ taskName: String) {
        let task = Task(context: context)
        task.name = taskName
        taskList.append(task)
        saveContext()
    }
    
    func editTask(at indexPath: IndexPath, _ taskName: String) {
        let task = taskList[indexPath.row]
        task.name = taskName
        taskList[indexPath.row] = task
        saveContext()
    }
    
    func deleteTask(at indexPath: IndexPath) {
        let task = taskList.remove(at: indexPath.row)
        context.delete(task)
        saveContext()
    }
    
}
