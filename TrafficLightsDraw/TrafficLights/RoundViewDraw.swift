//
//  RoundViewDraw.swift
//  TrafficLights
//
//  Created by  Paul on 07.12.2021.
//

import UIKit

@IBDesignable
class RoundViewDraw: UIView
{
    // MARK: - Public vars
    
    @IBInspectable
    var color: UIColor = .red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = .systemGray {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var scale: CGFloat = 0.9 { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var lineWidth: CGFloat = 6.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: - Private vars
    
    private var circleRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    private var circleCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func draw(_ rect: CGRect) {
        borderColor.set()
        pathForCircle().stroke()
        color.set()
        pathForCircle().fill()
    }
    
    // MARK: - Private functions
    
    private func pathForCircle() -> UIBezierPath {
        let path = UIBezierPath(arcCenter: circleCenter, radius: circleRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false)
        path.lineWidth = lineWidth
        return path
    }
}
