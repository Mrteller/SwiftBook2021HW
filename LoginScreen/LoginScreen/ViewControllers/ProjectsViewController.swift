//
//  ProjectsViewController.swift
//  LoginScreen
//
//  Created by  Paul on 18.12.2021.
//

import UIKit

class ProjectsViewController: UITableViewController {
    
    // MARK: - @IBOutlets

    // MARK: - Private vars
    
    var projecs: [Person.Project]!
    
    // MARK: - Lifecycle methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "cellToWebView") {
            
            let webViewController = segue.destination.allContentControllersOf(type: WebViewController.self).first
            let cell = sender as? UITableViewCell
            webViewController?.title = cell?.textLabel?.text
            webViewController?.url = URL(string: cell?.detailTextLabel?.text ?? "")
        }
    }

    // MARK: Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        projecs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath)
        cell.textLabel?.text = projecs[indexPath.row].name
        cell.detailTextLabel?.text = projecs[indexPath.row].htmlURL.absoluteString
        return cell
    }


}
