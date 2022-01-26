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
        let container = NSPersistentContainer(name: "GitAuthorsAndCommits")
        container.loadPersistentStores { (storeDescription, error) in // load existing or create new database on disk otherwise
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            if let error = error {
                print("Inresolved error \(error.localizedDescription)")
            }
        }
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
