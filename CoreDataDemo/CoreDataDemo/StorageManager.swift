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

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Initializers
    
    private init() { }
    
    // MARK: - Public funcs
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    

}
