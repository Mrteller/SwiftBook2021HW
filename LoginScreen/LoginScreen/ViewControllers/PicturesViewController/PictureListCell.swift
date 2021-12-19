//
//  PictureVerticalListCell.swift
//  LoginScreen
//
//  Created by  Paul on 18.12.2021.
//

import Foundation
import UIKit

class PictureListCell: UICollectionViewListCell {
    
    // MARK: - Public vars
    
    var item: PictureItem?
    var indexPath: IndexPath?
    
    // MARK: - Lifecycle methods
    
    override func updateConfiguration(using state: UICellConfigurationState) {

        var newBgConfiguration = UIBackgroundConfiguration.listGroupedCell()
        newBgConfiguration.backgroundColor = .systemBackground
        backgroundConfiguration = newBgConfiguration
            
        var newConfiguration = PictureContentConfiguration().updated(for: state)
        
        newConfiguration.name = item?.name
        newConfiguration.symbol = item?.image
        newConfiguration.indexPath = indexPath

        contentConfiguration = newConfiguration
    }
    
}
