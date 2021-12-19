//
//  SFSymbolContentConfiguration.swift
//  LoginScreen
//
//  Created by  Paul on 18.12.2021.
//

import Foundation
import UIKit

struct PictureContentConfiguration: UIContentConfiguration, Hashable {
    
    // MARK: - Public vars

    var name: String?
    var symbol: UIImage?
    var indexPath: IndexPath?
    var nameColor: UIColor?
    var symbolWeight: UIImage.SymbolWeight?
    var fontWeight: UIFont.Weight?
    var backgroundColor: UIColor?
    
    // MARK: - Public funcs
    
    func makeContentView() -> UIView & UIContentView {
        return PictureContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        
        guard let state = state as? UICellConfigurationState else {
            return self
        }
        
        var updatedConfiguration = self
        if state.isSelected {
            updatedConfiguration.nameColor = .systemPink
            updatedConfiguration.symbol = symbol?.withRenderingMode(.alwaysOriginal)
            updatedConfiguration.fontWeight = .heavy
            updatedConfiguration.symbolWeight = .heavy
        } else {
            updatedConfiguration.nameColor = .systemBlue
            updatedConfiguration.fontWeight = .regular
            updatedConfiguration.symbolWeight = .regular
        }

        if let indexPath = indexPath, indexPath.row.isMultiple(of: 2) {
            // TODO: refactor to support Dark theme. Probably move to `updateConfiguration(using state: UICellConfigurationState)`
            updatedConfiguration.backgroundColor = .tintColor.withAlphaComponent(0.1)
        }
    
        return updatedConfiguration
    }
    
}
