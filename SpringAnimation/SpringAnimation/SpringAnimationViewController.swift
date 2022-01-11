//
//  SpringAnimationViewController.swift
//  SpringAnimation
//
//  Created by  Paul on 11.01.2022.
//

import Spring

class SpringAnimationViewController: UIViewController {

    // MARK: - @IBOutlets
    
    @IBOutlet weak var springView: SpringView!
    @IBOutlet weak var springButton: SpringButton!
    
    
    
    // MARK: - Public vars
    
    // MARK: - Private vars
    
    private var currentAnimation = Spring.AnimationPreset.fadeIn
    private var currentCurve = Spring.AnimationCurve.easeIn
    
    // MARK: - Initializers
    
    // MARK: - Lifecycle methods
    
    // MARK: - @IBActions
    
    @IBAction func springButtonPressed() {
        
        setOptions()
        springView.animate()
        
    }
    
    // MARK: - Public funcs
    
    // MARK: - Private funcs

    private func setOptions() {
        springView.force = CGFloat.random(in: 1...5)
        springView.duration = CGFloat.random(in: 0.5...5)
        springView.delay = CGFloat.random(in: 0...0.5)
        
        springView.damping = CGFloat.random(in: 0...1)
        springView.velocity = CGFloat.random(in: 0...1)
//        springView.scaleX = CGFloat.random(in: 1...5)
//        springView.scaleY = CGFloat.random(in: 1...5)
//        springView.x
//        springView.y
//        springView.rotate
        
        springView.animation = currentAnimation.switchToNextLooped().rawValue
        springView.curve = currentCurve.switchToNextLooped().rawValue
    }

}

extension CaseIterable where Self: Equatable {
    @discardableResult
    mutating func switchToNextLooped() -> Self {
        let all = Self.allCases
        let idx = all.firstIndex(of: self)!
        let next = all.index(after: idx)
        self = all[next == all.endIndex ? all.startIndex : next]
        return self
    }
}

extension BinaryFloatingPoint {
    func fractionDigits(_ max: Int, _ min: Int = 0, roundingMode: NumberFormatter.RoundingMode = .halfEven) -> String {
        let number = NumberFormatter()
        number.roundingMode = roundingMode
        number.maximumFractionDigits = max
        number.minimumFractionDigits = min
        return number.string(for: self) ?? ""
    }
}

