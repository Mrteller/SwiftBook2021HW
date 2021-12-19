//
//  PictureContentView.swift
//  LoginScreen
//
//  Created by  Paul on 18.12.2021.
//

import Foundation
import UIKit

class PictureContentView: UIView, UIContentView {
    
    // MARK: - Public vars
    
    let nameLabel = UILabel()
    let pictureImageView = UIImageView()

    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        }
        set {
            guard let newConfiguration = newValue as? PictureContentConfiguration else { return }
            apply(configuration: newConfiguration)
        }
    }
    
    // MARK: - Private vars
    
    private var currentConfiguration: PictureContentConfiguration!
    
    // MARK: - Initializers
    
    init(configuration: PictureContentConfiguration, axis: NSLayoutConstraint.Axis = .vertical) {
        super.init(frame: .zero)
        
        setupAllViews(axis: axis)
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private funcs
    
    private func setupAllViews(axis: NSLayoutConstraint.Axis = .vertical) {
        
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.alignment = .fill
        stackView.distribution = .fill
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ])
        
        pictureImageView.contentMode = .scaleAspectFit
        stackView.addArrangedSubview(pictureImageView)
        
        nameLabel.textAlignment = .center
        stackView.addArrangedSubview(nameLabel)
    }
    
    private func apply(configuration: PictureContentConfiguration) {
    
        guard currentConfiguration != configuration else { return }
        currentConfiguration = configuration

        nameLabel.text = configuration.name
        nameLabel.textColor = configuration.nameColor
        
        if let fontWeight = configuration.fontWeight {
            nameLabel.font = UIFont.systemFont(ofSize: nameLabel.font.pointSize, weight: fontWeight)
        }
        
        if
            let symbolWeight = configuration.symbolWeight {
            // TODO: some better logic for `pointSize` or for `pictureImageView`
            let symbolConfig = UIImage.SymbolConfiguration(pointSize: 80, weight: symbolWeight)
            let symbol = configuration.symbol?.withConfiguration(symbolConfig)
            pictureImageView.image = symbol
        }
        
        backgroundColor = configuration.backgroundColor
    }
}
