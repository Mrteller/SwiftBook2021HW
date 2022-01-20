import Foundation
import UIKit

struct SimpleNameContentConfiguration: UIContentConfiguration, Hashable {

    var name: String?
    
    func makeContentView() -> UIView & UIContentView {
        // Initialize an instance of SimpleNameContentView
        return SimpleNameContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
}
