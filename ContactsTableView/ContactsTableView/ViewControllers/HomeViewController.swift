//
//  HomeViewController.swift
//  ContactsTableView
//
//  Created by  Paul on 28.12.2021.
//

import UIKit

class HomeViewController: UITabBarController {
    
    // MARK: - Private vars
    
    private var persons = [Person]()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        persons = Person.randomPersons()
        // TODO: refactor with `firstContentControllerOf<T : UIViewController>(type : T.Type)`
        if let nameController = (viewControllers?[0] as? UINavigationController)?.viewControllers.first as? NamesViewController {
            nameController.persons = persons
            // TODO: pass a clousure to update the "source of truth" `persons` here
        }
        if let contactsController = (viewControllers?[1] as? UINavigationController)?.viewControllers.first as? ContactsViewController {
            contactsController.persons = persons
        }
    }

}

