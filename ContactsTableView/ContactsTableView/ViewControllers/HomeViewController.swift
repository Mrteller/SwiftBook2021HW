//
//  HomeViewController.swift
//  ContactsTableView
//
//  Created by  Paul on 28.12.2021.
//

import UIKit

class HomeViewController: UITabBarController {
    
    // MARK: - Private vars
    
    private var persons = Person.randomPersons()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataIntoControllers()
    }
    
    // MARK: - Private funcs
    
    private func loadDataIntoControllers() {
        if let nameController = firstContentControllerOf(type: NamesViewController.self)  {
            nameController.persons = persons
            // TODO: pass a clousure to update the "source of truth" `persons` here
        }
        if let contactsController = firstContentControllerOf(type: ContactsViewController.self)  {
            contactsController.persons = persons
        }
    }

}

