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
    
    @IBOutlet weak var forceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var delayLabel: UILabel!
    @IBOutlet weak var dampingLabel: UILabel!
    @IBOutlet weak var velocityLabel: UILabel!
    
    // MARK: - Private vars
    
    private var currentAnimation = Spring.AnimationPreset.fadeIn
    private var currentCurve = Spring.AnimationCurve.easeIn
    
    // MARK: - @IBActions
    
    @IBAction func springButtonPressed() {
        setOptions()
        updateSpringView()
    }
    
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
    
    func updateSpringView() {
        springButton.setTitle("Animation " + springView.animation, for: .normal)
        UIView.transition(with: springView,
                          duration: 0.8,
                          options: .transitionCrossDissolve) { [weak self] in
            guard let self = self else { return }
            self.forceLabel.text = "Force: " + self.springView.force.fractionDigits(2)
            self.durationLabel.text = "Duration: " + self.springView.duration.fractionDigits(2)
            self.delayLabel.text = "Delay: " + self.springView.delay.fractionDigits(2)
            self.dampingLabel.text = "Damping: " + self.springView.damping.fractionDigits(2)
            self.velocityLabel.text = "Velocity: " + self.springView.velocity.fractionDigits(2)
        } completion: { [weak self] _ in
            self?.springView.animate()
        }
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

