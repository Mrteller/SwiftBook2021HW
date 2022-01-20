//
//  MenuViewController.swift
//  ModernAsyncAndCollection
//
//  Created by  Paul on 16.01.2022.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Task(priority: .userInitiated) {
            let r = await NetworkManager.shared.fetchAndDecodeFilms()
            print(r)
        }
        NetworkManager.shared.fetchAndDecodeFilmsaAM { result in
            print(result)
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "regularJSONparsing":
            Task(priority: .userInitiated) {
    //            let r1 = await fetchResource(Resources<Film>.self)
    //            print(r1)
                let result = await NetworkManager.shared.fetchResource(Resources<Film>.self, id: "1" )
                switch result {
                case .success(let resource):
                    print("Number of items \(resource.results?.count ?? 0)")
                    guard let titles = resource.results?.compactMap(\.title) else { return }
                    print(titles)
                    
                    if let vc = segue.destination as? SimpleListViewController {
                        vc.dataItems = titles.map(SimpleItem.init)
                        vc.updateSnapshot() // it is safe to call `apply(snapshot)` in background
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
        case "serializedJSONparsing":
            Task(priority: .userInitiated) {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                let result = await NetworkManager.shared.fetchAndDecodeFilms()
                switch result {
                case .success(let resource):
                    print("Number of items \(resource.results?.count ?? 0)")
                    guard let titles = resource.results?.compactMap(\.title) else { return }
                    print(titles)
                    
                    if let vc = segue.destination as? SimpleListViewController {
                        vc.dataItems = titles.map(SimpleItem.init)
                        vc.updateSnapshot() // it is safe to call `apply(snapshot)` in background
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case "manualAlamorfireJSONparsing":
            NetworkManager.shared.fetchAndDecodeFilmsAMRefactored { result in
                switch result {
                case .success(let resource):
                    print("Number of items \(resource.results?.count ?? 0)")
                    guard let titles = resource.results?.compactMap(\.title) else { return }
                    print(titles)
                    print(Thread.current.description)
                    if let vc = segue.destination as? SimpleListViewController {
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
    
}

