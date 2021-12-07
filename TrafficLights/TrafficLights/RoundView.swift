//
//  RoundView.swift
//  TrafficLights
//
//  Created by  Paul on 07.12.2021.
//

import UIKit

@IBDesignable

class RoundView: UIView {
    
    // MARK: - Public vars
    @IBInspectable var radius: CGFloat = 5 {
        didSet {
            layer.cornerRadius = radius
            setNeedsLayout()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
            setNeedsLayout()
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
            setNeedsLayout()
        }
    }

    @IBInspectable var autoMaxCornerRadius: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadow: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowColor: UIColor = UIColor.black {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = .zero {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    // MARK: - Lifecycle methods
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if autoMaxCornerRadius {
            let maxSide = min(layer.bounds.width, layer.bounds.height)
            layer.cornerRadius = maxSide/2.0
        } else {
            layer.cornerRadius = radius
        }
    
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        layer.masksToBounds = layer.borderWidth > 0
            
        if shadow {
            layer.shadowColor = self.shadowColor.cgColor
            layer.shadowOffset = self.shadowOffset
            layer.shadowRadius = self.shadowRadius
            layer.shadowOpacity = self.shadowOpacity
            layer.masksToBounds = false
        }
        
    }
    
    override func prepareForInterfaceBuilder() {
        setNeedsLayout()
    }
}
