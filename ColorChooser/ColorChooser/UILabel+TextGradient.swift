//
//  UILabel+TextGradient.swift
//  ColorChooser
//
//  Created by  Paul on 12.12.2021.
//

import UIKit

extension UILabel {
    @discardableResult
    func applyGradientWith(colors: [UIColor], vertical: Bool = false) -> Bool {

        guard let gradientText = text, let font = font else { return false }
        let textSize = gradientText.size(withAttributes: [.font : font])

        UIGraphicsBeginImageContext(CGSize(width: textSize.width, height: textSize.height))

        guard let context = UIGraphicsGetCurrentContext()
        else {
            UIGraphicsEndImageContext()
            return false
        }

        UIGraphicsPushContext(context)

        let locations = (0..<colors.count).map{ CGFloat($0) }

        guard let textGradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors.map{ $0.cgColor } as CFArray, locations: locations) else { return false }
        
        let startPoint, endPoint: CGPoint
        
        if vertical {
            startPoint = .zero
            endPoint = CGPoint(x: 0, y: textSize.height)
        } else {
            startPoint = .zero
            endPoint = CGPoint(x: textSize.width, y: textSize.height / 2)
        }

        context.drawLinearGradient(textGradient, start: startPoint, end: endPoint, options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])

        UIGraphicsPopContext()

        guard let gradientImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return false
        }

        UIGraphicsEndImageContext()

        textColor = UIColor(patternImage: gradientImage)

        return true
    }

}
