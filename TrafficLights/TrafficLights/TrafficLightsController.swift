//
//  TrafficLightsController.swift
//  TrafficLights
//
//  Created by  Paul on 07.12.2021.
//

import UIKit

class TrafficLightsController: UIViewController {

    // MARK: - @IBOutlets
    @IBOutlet var lights: [RoundView]!
    @IBOutlet weak var switchLightButton: GradientButton!
    
    // MARK: - Public vars
    var trafficLight : TrafficLight = .red {
        didSet {
            let animation = UIViewPropertyAnimator(duration: 2, dampingRatio: 0.5) { [unowned self] in
                lights.forEach{ $0.alpha = 0.3 }
                lights.first(where: { $0.tag == trafficLight.rawValue })?.alpha = 1
            }
            animation.startAnimation()
            switch trafficLight {
            case .red:
                haptic(feedback: .error)
            case .yellow:
                haptic(feedback: .warning)
            case .green:
                haptic(feedback: .success)
            }
        }
    }
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Switched the whole app to dark mode using UIUserInterfaceStyle option in Info.plist
        //overrideUserInterfaceStyle = .dark
    }

    // MARK: - @IBActions
    @IBAction func switchLightButtonTapped() {
        switchLightButton.setTitle("Next", for: .normal)
        trafficLight.toggleNext()
    }
}

// MARK: - Auxiliary types and funcs

enum TrafficLight: Int, CaseIterable {
    case red = 1, yellow, green
    
    mutating func toggleNext() {
        let rValue = self.rawValue
        if rValue == Self.allCases.map(\.rawValue).max() {
            self = Self.init(rawValue: Self.allCases.map(\.rawValue).min() ?? 1) ?? .red
        } else {
            self = Self.init(rawValue: rValue.advanced(by: 1)) ?? .red
        }
        
    }
}

fileprivate func haptic(feedback: UINotificationFeedbackGenerator.FeedbackType) {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(feedback)
}
