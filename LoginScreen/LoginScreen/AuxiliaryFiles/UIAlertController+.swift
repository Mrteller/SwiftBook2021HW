//
//  UIAlertController+.swift
//  LoginScreen
//
//  Created by  Paul on 14.12.2021.
//
import UIKit

// MARK: - Initializers
extension UIAlertController {
	
    /// Create new alert view controller.
    ///
    /// - Parameters:
    ///   - style: alert controller's style.
    ///   - title: alert controller's title.
    ///   - message: alert controller's message (default is nil).
    ///   - tintColor: alert controller's tint color (default is nil). if set overrides actionButton tint
    convenience init(style: UIAlertController.Style, source: UIView? = nil, title: String? = nil, message: String? = nil, tintColor: UIColor? = nil) {
        self.init(title: title, message: message, preferredStyle: style)
        
        view.tintColor = tintColor
    }
}

// MARK: - Methods
extension UIAlertController {

    /// Add an action to Alert
    ///
    /// - Parameters:
    ///   - title: action title
    ///   - style: action style (default is UIAlertActionStyle.default)
    ///   - isEnabled: isEnabled status for action (default is true)
    ///   - handler: optional action handler to be called when button is tapped (default is nil)
    func addAction(image: UIImage? = nil, title: String, color: UIColor? = .tintColor, style: UIAlertAction.Style = .default, isEnabled: Bool = true, handler: ((UIAlertAction) -> Void)? = nil) {
        
        let action = UIAlertAction(title: title, style: style, handler: handler)
        action.isEnabled = isEnabled
        
        action.setValue(image, forKey: "image")
        action.setValue(color, forKey: "titleTextColor")
  
        addAction(action)
    }
    
    /// Set alert's title, font and color
    ///
    /// - Parameters:
    ///   - title: alert title
    ///   - font: alert title font
    ///   - color: alert title color
    func set(title: String?, font: UIFont, color: UIColor = .label) {
        guard let title = title else {
            self.title = title
            return
        }
        
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color]
        let attributedTitle = NSMutableAttributedString(string: title, attributes: attributes)
        setValue(attributedTitle, forKey: "attributedTitle")
    }
    
    /// Set alert's message, font and color
    ///
    /// - Parameters:
    ///   - message: alert message
    ///   - font: alert message font
    ///   - color: alert message color
    func set(message: String?, font: UIFont, color: UIColor = .label) {
        guard let message = message else {
            self.message = message
            return
        }

        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color]
        let attributedMessage = NSMutableAttributedString(string: message, attributes: attributes)
        setValue(attributedMessage, forKey: "attributedMessage")
    }
    
}

