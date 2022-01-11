//
//  ViewController.swift
//  SpringAnimation
//
//  Created by  Paul on 11.01.2022.
//

import Spring

class ViewController: UIViewController {

    // MARK: - @IBOutlets
    
    // MARK: - Public vars
    
    // MARK: - Private vars
    
    // MARK: - Initializers
    
    // MARK: - Lifecycle methods
    
    // MARK: - @IBActions
    
    // MARK: - Public funcs
    
    // MARK: - Private funcs


}

extension CaseIterable where Self: Equatable {
    func next() -> Self {
        let all = Self.allCases
        let idx = all.firstIndex(of: self)!
        let next = all.index(after: idx)
        return all[next == all.endIndex ? all.startIndex : next]
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

