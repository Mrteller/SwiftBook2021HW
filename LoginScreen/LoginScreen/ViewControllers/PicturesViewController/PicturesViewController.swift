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
        
        let layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        
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
        
        let cellRegistration = UICollectionView.CellRegistration<PictureListCell, PictureItem> { (cell, indexPath, item) in
            
            cell.item = item
            cell.indexPath = indexPath
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, PictureItem>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: PictureItem) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                    for: indexPath,
                                                                    item: identifier)
            return cell
        }
        
        snapshot = NSDiffableDataSourceSnapshot<Section, PictureItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(dataItems, toSection: .main)
        
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
