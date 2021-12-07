//
//  GradientButton.swift
//  TrafficLights
//
//  Created by  Paul on 07.12.2021.
//

import UIKit
@IBDesignable class GradientButton: UIButton {
    
    // MARK: - Public vars
    // TODO: implement `didSet`s and call `setNeedsDisplay()` or `setNeedsLayout()`
    @IBInspectable var startColor: UIColor = .white
    @IBInspectable var endColor: UIColor = .white
    @IBInspectable var cornerRadius = CGFloat(5.0)
    @IBInspectable var borderWidth = CGFloat(1.0)
    @IBInspectable var borderColor: UIColor = .lightGray
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.minimumScaleFactor = 0.2
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        titleLabel?.minimumScaleFactor = 0.2
        titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    // MARK: - Override vars
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    // MARK: - Lifecycle methods
    override func layoutSubviews() {
        super.layoutSubviews()
        
        (layer as! CAGradientLayer).colors = [startColor.cgColor, endColor.cgColor]
        
        // Controll round corners and border here.
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
    
    override func prepareForInterfaceBuilder() {
        // setNeedsDisplay()
        setNeedsLayout()
    }
}
