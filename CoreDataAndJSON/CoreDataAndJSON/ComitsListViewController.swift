//
//  ComitsListViewController.swift
//  CoreDataAndJSON
//
//  Created by  Paul on 26.01.2022.
//

import UIKit
import CoreData

class ComitsListViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    private var diffableDataSource: StringConvertibleTableViewDiffibleDataSource<String, Commit>!
    private var commitPredicate: NSPredicate?
    private var fetchedResultsController: NSFetchedResultsController<Commit>!
    
    @IBAction func refresh(_ sender: UIRefreshControl) {
        performSelector(inBackground: #selector(fetchCommits), with: nil) // Better pass newestCommitDate as argument
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        performSelector(inBackground: #selector(fetchCommits), with: nil) // Compare with other background fetching techniques
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(changeFilter))
    }
    
    @objc func fetchCommits() { // Make real error handling someday and move to NetworkManager
        let newestCommitDate = getNewestCommitDate() // is run in background, but uses viewContext (which is a main ViewContext)
        if let data = try? String(contentsOf: URL(string: "https://api.github.com/repos/apple/swift/commits?per_page=100&since=\(newestCommitDate)")!) {
            // give the data to SwiftlyJSON to parse
            let jsonCommits = JSON(parseJSON: data)
            // read the commits back out
            let jsonCommitArray = jsonCommits.arrayValue
            print("Received \(jsonCommitArray.count) new commits.")
            
            // Do we really need to dispatch back or we can just thread-protect block?
            //             container.viewContext.perform { }
            // The other thing we could do instead of DispatchQueue.main.async is:
            //            container.performBackgroundTask { [unowned self] backgroundContext in
            //                for jsonCommit in jsonCommitArray {
            //                    let commit = Commit(context: backgroundContext)
            //                    self.configure(commit: commit, usingJSON: jsonCommit)
            //                }
            //                try? backgroundContext.save()
            //                self.loadSavedData()
            //                self.refreshControl?.endRefreshing()
            //            }
            DispatchQueue.main.async { [unowned self] in
                
                for jsonCommit in jsonCommitArray {
                    let commit = Commit(context: StorageManager.shared.persistentContainer.viewContext)
                    self.configure(commit: commit, usingJSON: jsonCommit)
                }
                self.saveContext() // That's right: viewContext is main thread context and should be saved (and operated) on main thread only. Even Asycncroniously.
                self.loadSavedData()
                self.refreshControl?.endRefreshing()
            }
        } else {
            self.refreshControl?.endRefreshing()
        }
    }
    
    func getNewestCommitDate() -> String {
        let formatter = ISO8601DateFormatter()
        let newest = Commit.createFetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: false)
        newest.sortDescriptors = [sort]
        newest.fetchLimit = 1
        newest.propertiesToFetch = ["date"] // we can avoid fetching thing we don't need
        // print("Date.distantPast \(Date.distantPast) vs Date(timeIntervalSince1970:) \(Date(timeIntervalSince1970: 0))")
        
        // if let commits = try? container.viewContext.fetch(newest) {
#if DEBUG
        print("Fetching or executing request on \(Thread.isMainThread ? "Main" : "Background") thread :\r\(#file) (\(#line)) \(#function)")
#endif
        // NOTE: `getNewestCommitDate` gets called from `fetchCommits` which in its turn is run in background. We are not allowed to use `viewContext` off the main queue ("view" is for UI what is for main tread).
        if let commits = try? newest.execute(), // Fetching with `execute` will choose a proper NSManagedContext for whatever queue we are in.
           let date = commits.first?.date {
            if commits.count > 0 {
                // print(formatter.string(from: date.addingTimeInterval(1)))
                return formatter.string(from: date.addingTimeInterval(1))
            }
        }
        return formatter.string(from: Date(timeIntervalSince1970: 0))
    }
    
    private func configure(commit: Commit, usingJSON json: JSON) {
        commit.sha = json["sha"].stringValue
        commit.message = json["commit"]["message"].stringValue
        commit.url = json["html_url"].stringValue
        
        let formatter = ISO8601DateFormatter()
        commit.date = formatter.date(from: json["commit"]["committer"]["date"].stringValue) ?? Date()
        // print(commit.date, json["commit"]["committer"]["date"].stringValue)
        
        var commitAuthor: Author!
        // see if this author exists already
        let authorRequest = Author.createFetchRequest()
        // Danger! - we might have authors with the same name. TODO: check if it is unique. if not we are about to mix them here.
        //authorRequest.predicate = NSPredicate(format: "name == %@ AND email == %@", json["commit"]["committer"]["name"].stringValue, json["commit"]["committer"]["email"].stringValue)
        authorRequest.predicate = NSPredicate(format: "name == %@",json["commit"]["committer"]["name"].stringValue)
        //if let authors = try? container.viewContext.fetch(authorRequest) {
        // This is safer. Entities are linked and are considered to be in one context (view, background, other)
        if let authors = try? commit.managedObjectContext!.fetch(authorRequest) {
            // if let authors = try? authorRequest.execute() // This is good too. `execute()` will use a proper context (according to the current queue).
            if authors.count > 0 {
                // we have this author already
                assert(authors.count == 1, "DB inconsitency: too many authors with the same name")
                commitAuthor = authors[0]
            }
        }
        if commitAuthor == nil {
            // We didn't find a saved author - create a new one.
            let author = Author(context: commit.managedObjectContext!) // Again - it is better to use the same context that related entity uses.
            author.name = json["commit"]["committer"]["name"].stringValue
            author.email = json["commit"]["committer"]["email"].stringValue
            commitAuthor = author
        }
        
        // use the author, either saved or new
        commit.author = commitAuthor
    }
    
    @objc private func saveContext() {
        StorageManager.shared.saveContext()
    }
    
    @objc private func changeFilter() {
        // Change to segmented control with search item
        let ac = UIAlertController(title: "Filter commits...", message: nil, preferredStyle: .actionSheet)
        //1
        ac.addAction(UIAlertAction(title: "Show only fixes", style: .default) { [unowned self] _ in
            self.commitPredicate = NSPredicate(format: "message CONTAINS[c] 'fix'")
            self.loadSavedData()
        })
        //2
        ac.addAction(UIAlertAction(title: "Ignore Pull Requests", style: .default) { [unowned self] _ in
            self.commitPredicate = NSPredicate(format: "NOT message BEGINSWITH 'Merge pull request'")
            self.loadSavedData()
        })
        //3.1
        ac.addAction(UIAlertAction(title: "Show only resent", style: .default) { [unowned self] _ in
            let twelveHoursAgo = Date().addingTimeInterval(-43200)
            self.commitPredicate = NSPredicate(format: "date > %@", twelveHoursAgo as NSDate)
            self.loadSavedData()
        })
        // 3.2
        ac.addAction(UIAlertAction(title: "Show only Durian commits", style: .default) { [unowned self] _ in
            self.commitPredicate = NSPredicate(format: "author.name == 'Joe Groff'")
            self.loadSavedData()
        })
        //4
        ac.addAction(UIAlertAction(title: "Show all commits", style: .default) { [unowned self] _ in
            self.commitPredicate = nil
            self.loadSavedData()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: !UIAccessibility.isReduceMotionEnabled)
        
    }
    
    private func loadSavedData() {
        if fetchedResultsController == nil {
            let request = Commit.createFetchRequest()
            let authorName = NSSortDescriptor(key: "author.name", ascending: true) // Must include the key we use in `sectionNameKeyPath`
            let sort = NSSortDescriptor(key: "date", ascending: false)
            request.sortDescriptors = [authorName, sort]
            request.fetchBatchSize =  20 // Now it is clear what this thing does
            
            fetchedResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: StorageManager.shared.persistentContainer.viewContext,
                sectionNameKeyPath: "author.name", cacheName: nil)
            fetchedResultsController.delegate = self
        }
        
        fetchedResultsController.fetchRequest.predicate = commitPredicate
        do {
            //commits = try container.viewContext.fetch(request)
            //print("Got \(commits.count) commits")
            try fetchedResultsController.performFetch()
            generateAndApplySnapshot()
        } catch  {
            print("Fetch failed")
        }
    }
    
    private func setupTableView() {
//        tableView.register(TitleSupplementaryView.self, forHeaderFooterViewReuseIdentifier: "headerID")
        diffableDataSource = StringConvertibleTableViewDiffibleDataSource<String, Commit>(tableView: tableView) { (tableView, indexPath, commit) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Commit", for: indexPath)
            cell.configure(with: commit)
            return cell
        }
    }
    
    private func generateAndApplySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<String, Commit>()
        fetchedResultsController.sections?.forEach {
            snapshot.appendSections([$0.name])
            snapshot.appendItems(($0.objects as? [Commit]) ?? [], toSection: $0.name)
        }
        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: Table
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            //vc.detailItem = commits[indexPath.row] //Pauls note: better make it independent of Commits class
            vc.detailItem = fetchedResultsController.object(at: indexPath)
            navigationController?.pushViewController(vc, animated: !UIAccessibility.isReduceMotionEnabled)
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "") { [weak self] (action, view, completion) in
            guard let commit = self?.fetchedResultsController.object(at: indexPath) else { return }
            commit.managedObjectContext?.delete(commit)
            //StorageManager.shared.persistentContainer.viewContext.delete(commit)
            self?.saveContext()
        }
        delete.backgroundColor = .systemRed
        delete.title = "Delete"
        //delete.image = UIImage(systemName: "trash")
        
        let config = UISwipeActionsConfiguration(actions: [delete])
        config.performsFirstActionWithFullSwipe = false
        
        return config
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerID") as? TitleSupplementaryView
//        else {
//            return nil
//        }
//        //header.label.text = diffableDataSource.sectionIdentifier(for: section) // works
//        header.label.text = fetchedResultsController.sections?[section].name
//        header.label.textColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
//        header.label.textAlignment = .center
//        return header
//    }
    

    
    // MARK: NSFetchedResultsControllerDelegate
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type { // for future implementation
        case .delete:
            // Show alert
            // Exclude overhead of creating new snapshot when possible
            var snapshot = diffableDataSource.snapshot()
            guard let commit = anObject as? Commit else {
                generateAndApplySnapshot()
                return
            }
            if let section = snapshot.sectionIdentifier(containingItem: commit), snapshot.numberOfItems(inSection: section) == 1 {
                snapshot.deleteSections([section])
            }
            snapshot.deleteItems([commit])
            
            diffableDataSource.apply(snapshot, animatingDifferences: true)
            
        default:
            generateAndApplySnapshot()
        }
    }
    
}

private extension UITableViewCell {
    func configure(with commit: Commit) {
        var configuration = defaultContentConfiguration()
        configuration.text = commit.message
        configuration.secondaryText = "By \(commit.author.name) on \(commit.date.description)"
        contentConfiguration = configuration
        
    }
}

class StringConvertibleTableViewDiffibleDataSource<UserSection: Hashable, User: Hashable>: UITableViewDiffableDataSource<UserSection, User> where UserSection: CustomStringConvertible{
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionIdentifier(for: section)?.description
    }
}
