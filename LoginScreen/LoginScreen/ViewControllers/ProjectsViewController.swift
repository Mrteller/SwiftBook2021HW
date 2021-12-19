//
//  ProjectsViewController.swift
//  LoginScreen
//
//  Created by  Paul on 18.12.2021.
//

import UIKit

class ProjectsViewController: UITableViewController, UISplitViewControllerDelegate {
    
    // MARK: - @IBOutlets

    // MARK: - Private vars
    
    var projecs: [Person.Project]!
    
    // MARK: - Lifecycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.splitViewController?.delegate = self
    }
    
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
        // FIXME: This way of managing cells is about to become deprecated. See `PicturesViewController` for modern implementation
        let project = projecs[indexPath.row]
        cell.textLabel?.font = .preferredFont(forTextStyle: .headline)
        cell.textLabel?.text = project.name
        cell.detailTextLabel?.font = .preferredFont(forTextStyle: .caption1)
        cell.detailTextLabel?.textColor = .link
        cell.detailTextLabel?.text = project.htmlURL.absoluteString
        cell.imageView?.image = UIImage(
            systemName: project.isFavorite ? "star.fill" : "star.slash.fill",
            withConfiguration: UIImage.SymbolConfiguration(textStyle: .largeTitle))
        return cell
    }
    
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController
    ) -> Bool {
        if primaryViewController.allContentControllersOf(type: type(of: self)).contains(self) {
            if let ivc = secondaryViewController.allContentControllersOf(type: WebViewController.self).first,
                ivc.url == nil {
                return true
            }
        }
        return false
    }


}
