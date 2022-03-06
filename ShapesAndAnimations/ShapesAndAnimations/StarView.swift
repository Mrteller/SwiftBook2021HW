//
//  StarView.swift
//  ShapesAndAnimations
//
//  Created by  Paul on 06.03.2022.
//

import SwiftUI

struct StarView: View {
    
    var count: CGFloat = 5
    var innerRatio: CGFloat = 1
    var scale = CGSize(width: 1, height: 1)
    
    let animation = Animation.easeInOut(duration: 1.5)
    
    var body: some View {
        ScaledShape(shape: Star(count: round(count), innerRatio: innerRatio), scale: scale)
            .fill(.ellipticalGradient(colors: [.red, .purple]))
            .aspectRatio(contentMode: .fit)
            .animation(animation, value: count)
            .animation(animation, value: innerRatio)
    }
}

struct Star: InsettableShape {
    
    var count: CGFloat
    var innerRatio: CGFloat
    
    var insetAmount = 0.0
    
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(count, innerRatio) }
        set {
            count = newValue.first
            innerRatio = newValue.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: (rect.width - insetAmount) * 0.5, y: (rect.height - insetAmount) * 0.5)
        let pointAngle = .pi / count
        
        let innerPoint = CGPoint(x: center.x * innerRatio * 0.5, y: center.y * innerRatio * 0.5)
        let totalPoints = Int(count * 2.0)
        
        var currentAngle = CGFloat.pi * -0.5
        var currentBottom: CGFloat = insetAmount
        
        var path = Path()
        path.move(to: CGPoint(x: center.x * cos(currentAngle),
                              y: center.y * sin(currentAngle)))
        
        let correction = count != round(count) ? 1 : 0
        for corner in 0..<totalPoints + correction  {
            var bottom: CGFloat = insetAmount
            let sin = sin(currentAngle)
            let cos = cos(currentAngle)
            if (corner % 2) == 0 {
                bottom = center.y * sin
                path.addLine(to: CGPoint(x: center.x * cos, y: bottom))
            } else {
                bottom = innerPoint.y * sin
                path.addLine(to: CGPoint(x: innerPoint.x * cos, y: bottom))
            }
            currentBottom = max(bottom, currentBottom)
            currentAngle += pointAngle
        }
        
        path.closeSubpath()
        
        let transform = CGAffineTransform(translationX: center.x + insetAmount / 2, y: center.y + (((rect.height + insetAmount) * 0.5 - currentBottom) * 0.5))
        return path.applying(transform)
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var star = self
        star.insetAmount += amount
        return star
    }
}

struct StarShape_Previews: PreviewProvider {
    static var previews: some View {
        StarView()
    }
}

