import Foundation
import UIKit

class SimpleNameListCell: UICollectionViewListCell {
    
    var item: SimpleItem?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        
        // Create new configuration object and update it base on state
        var newConfiguration = SimpleNameContentConfiguration().updated(for: state)
        
        // Update any configuration parameters related to data item
        newConfiguration.name = item?.name

        // Set content configuration in order to update custom content view
        contentConfiguration = newConfiguration
        
    }
}
