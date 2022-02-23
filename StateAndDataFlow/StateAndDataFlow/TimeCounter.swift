//
//  TimeCounter.swift
//  StateAndDataFlow
//
//  Created by brubru on 21.02.2022.
//

import Foundation
import Combine

class TimeCounter: ObservableObject {
    
    var counter = 3
    var timer: Timer?
    var buttonTitle = "Start"
    
    func startTimer() {
        if counter > 0 {
            timer = Timer.scheduledTimer(
                timeInterval: 1,
                target: self,
                selector: #selector(updateCounter),
                userInfo: nil,
                repeats: true
            )
        }
        buttonDidTapped()
    }
    
    @objc private func updateCounter() {
        if counter > 0 {
            counter -= 1
        } else {
            killTimer()
            buttonTitle = "Reset"
        }
        
        objectWillChange.send()
    }
    
    private func killTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func buttonDidTapped() {
        if buttonTitle == "Reset" {
            counter = 3
            buttonTitle = "Start"
        } else {
            buttonTitle = "Wait..."
        }
        
        objectWillChange.send()
    }
}
