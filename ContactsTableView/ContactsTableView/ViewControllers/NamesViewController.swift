//
//  NamesViewController.swift
//  ContactsTableView
//
//  Created by  Paul on 28.12.2021.
//

import UIKit

class NamesViewController: UITableViewController {
    
    // MARK: - Public vars
    
    var persons = [Person]()
    
    // MARK: - Lifecycle methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let contactInfoVC = segue.destination as? ContactInfoViewController,
              let indexPath = tableView.indexPathForSelectedRow else { return }
        contactInfoVC.person = persons[indexPath.row]
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        persons.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        configuration.text = persons[indexPath.row].fullName
        cell.contentConfiguration = configuration

        return cell
    }

}
