//
//  GradientTextLabel.swift
//  ColorChooser
//
//  Created by  Paul on 10.12.2021.
//

import UIKit

@IBDesignable
class GradientTextLabel: UILabel {
    
    // MARK: - Public vars
    @IBInspectable var startColor: UIColor = .red { didSet { setNeedsDisplay() } }
    @IBInspectable var midColor: UIColor = .orange { didSet { setNeedsDisplay() } }
    @IBInspectable var endColor: UIColor = .yellow { didSet { setNeedsDisplay() } }
    @IBInspectable var vertical: Bool = false { didSet { setNeedsDisplay() } }
    
    // MARK: - Lifecycle methods
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let gradient = getGradientLayer(bounds: bounds)
        textColor = gradientColor(bounds: bounds, gradientLayer: gradient)
        setNeedsDisplay()
    }
    
    override func prepareForInterfaceBuilder() {
        setNeedsDisplay()
    }
    
    // MARK: - Private methods
    private func getGradientLayer(bounds : CGRect) -> CAGradientLayer{
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [startColor.cgColor, midColor.cgColor, endColor.cgColor]
        
        if vertical {
            gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        } else {
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        
        return gradient
    }
    
    private func gradientColor(bounds: CGRect, gradientLayer :CAGradientLayer) -> UIColor? {
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        //create UIImage by rendering gradient layer.
        if let context = UIGraphicsGetCurrentContext(), let image = UIGraphicsGetImageFromCurrentImageContext() {
            gradientLayer.render(in: context)
            return UIColor(patternImage: image)
        }
        
        UIGraphicsEndImageContext()
        
        //get gradient UIcolor from gradient UIImage
        return textColor
    }
}
