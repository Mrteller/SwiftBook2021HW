//
//  PicturesViewController.swift
//  LoginScreen
//
//  Created by  Paul on 18.12.2021.
//

import UIKit

class PicturesViewController: UIViewController {
    
    // MARK: - Public vars
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, PictureItem>!
    var snapshot: NSDiffableDataSourceSnapshot<Section, PictureItem>!
    
    var pictures = [String]() {
        didSet {
            guard pictures != oldValue else { return }
            dataItems = pictures.map{ PictureItem(name: $0) }
            // TODO: call update collectionView func
        }
    }
    
    // MARK: - Private vars
    
    private var dataItems = [PictureItem]()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create list layout
        let layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        
        // Create collection view with list layout
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: listLayout)
        view.addSubview(collectionView)
        
        // Make collection view take up the entire view
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 0.0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0),
        ])
        
        // Create cell registration that define how data should be shown in a cell
        let cellRegistration = UICollectionView.CellRegistration<PictureListCell, PictureItem> { (cell, indexPath, item) in
            
            // For custom cell, we just need to assign the data item to the cell.
            // The custom cell's updateConfiguration(using:) method will assign the
            // content configuration to the cell
            cell.item = item
            cell.indexPath = indexPath
            
        }
        
        // Define data source
        dataSource = UICollectionViewDiffableDataSource<Section, PictureItem>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: PictureItem) -> UICollectionViewCell? in
            
            // Dequeue reusable cell using cell registration (Reuse identifier no longer needed)
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                    for: indexPath,
                                                                    item: identifier)
            return cell
        }
        
        // Create a snapshot that define the current state of data source's data
        snapshot = NSDiffableDataSourceSnapshot<Section, PictureItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(dataItems, toSection: .main)
        
        // Display data on the collection view by applying the snapshot to data source
        dataSource.apply(snapshot, animatingDifferences: false)
    }

}

// MARK: - Auxillary Types

// somewhat ViewModel
enum Section {
    case main
}

struct PictureItem: Hashable {
    let name: String
    let image: UIImage
    
    init(name: String) {
        self.name = name
        // temporary solution for development purposes
        self.image = (UIImage(contentsOfFile: name) ?? {
            let config = UIImage.SymbolConfiguration(pointSize: 50)
            return UIImage(systemName: name, withConfiguration: config)
        }()
        )!

    }
}
