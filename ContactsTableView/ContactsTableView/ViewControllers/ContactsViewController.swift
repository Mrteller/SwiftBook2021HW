//
//  ContactsViewController.swift
//  ContactsTableView
//
//  Created by  Paul on 28.12.2021.
//

import UIKit

class ContactsViewController: UITableViewController {
    
    
    // MARK: - Public vars
    
    var persons = [Person]()
    
    // MARK: - Lifecycle methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showContactInfo",
           let person = sender as? Person,
           let contactsInfoVC = segue.destination as? ContactInfoViewController {
            contactsInfoVC.person = person
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        persons.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        persons[section].fullName
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactsCell", for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        switch indexPath.row {
        case 0:
            configuration.text = persons[indexPath.section].phone
            configuration.image = UIImage(systemName: "phone")
        default:
            configuration.text = persons[indexPath.section].email
            configuration.image = UIImage(systemName: "envelope")
        }
        cell.contentConfiguration = configuration
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showContactInfo", sender: persons[indexPath.section])
    }

}
