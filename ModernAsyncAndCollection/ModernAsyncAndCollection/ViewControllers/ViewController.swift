//
//  ViewController.swift
//  ModernAsyncAndCollection
//
//  Created by  Paul on 16.01.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Task(priority: .userInitiated) {
            let r = await NetworkManager.shared.fetchAndDecodeFilms()
            print(r)
        }

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "regularJSONparsing":
            Task(priority: .userInitiated) {
    //            let r1 = await fetchResource(Resources<Film>.self)
    //            print(r1)
                let r2 = await NetworkManager.shared.fetchResource(Resources<Film>.self, id: "1" )
                switch r2 {
                case .success(let result):
                    print("Number of items \(result.results?.count ?? 0)")
                    guard let titles = result.results?.compactMap(\.title) else { return }
                    print(titles)
                    
                    if let vc = segue.destination as? NameListViewController {
                        vc.dataItems = titles.map(SimpleItem.init)
                        vc.updateSnapshot() // it is safe to call `apply(snapshot)` in background
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
        default:
            break
        }
    }
    
    @IBAction func regularJSONparsingPressed() {
        performSegue(withIdentifier: "regularJSONparsing", sender: nil)
    }
    
}

