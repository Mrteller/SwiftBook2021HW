import Foundation
import UIKit

class SimpleNameContentView: UIView, UIContentView {
    
    // 1
    // IBOutlet to connect to interface builder
    @IBOutlet var containerView: UIView!
    @IBOutlet var nameLabel: UILabel!
    
    private var currentConfiguration: SimpleNameContentConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        }
        set {
            // Make sure the given configuration is of type SimpleNameContentConfiguration
            guard let newConfiguration = newValue as? SimpleNameContentConfiguration else {
                return
            }
            
            // Set name to label
            apply(configuration: newConfiguration)
        }
    }
    
    init(configuration: SimpleNameContentConfiguration) {
        super.init(frame: .zero)
        
        // 2
        // Load SimpleNameContentView.xib
        loadNib()
        
        // Set name to label
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension SimpleNameContentView {
    
    private func loadNib() {
        
        // 3
        // Load SimpleNameContentView.xib by making self as owner of SimpleNameContentView.xib
        Bundle.main.loadNibNamed("\(SimpleNameContentView.self)", owner: self, options: nil)
        
        // 4
        // Add containerView as subview and make it cover the entire content view
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0),
        ])
        
        // 5
        // Add border & rounded corner to name label
        nameLabel.layer.borderWidth = 1.5
        nameLabel.layer.borderColor = UIColor.systemPink.cgColor
        nameLabel.layer.cornerRadius = 5.0
    }
    
    private func apply(configuration: SimpleNameContentConfiguration) {
    
        // Only apply configuration if new configuration and current configuration are not the same
        guard currentConfiguration != configuration else {
            return
        }
        
        // Replace current configuration with new configuration
        currentConfiguration = configuration
        
        // Set name to label
        nameLabel.text = configuration.name
    }
}
