//
//  GreetingViewController.swift
//  LoginScreen
//
//  Created by  Paul on 14.12.2021.
//

import UIKit

class GreetingViewController: UIViewController {
    
    // MARK: - @IBOutlets
    
    @IBOutlet weak var userGreetingLabel: UILabel! {
        didSet {
            userGreetingLabel.text = greetUser(user: userName)
        }
    }
    
    // MARK: - Public vars
    
    var userName: String?
    

    // MARK: - Private funcs
    
    private func greetUser(user name: String?, greeting: String = "Hello") -> String {
        if let name = name, !name.isEmpty {
            return "\(greeting), \(name)"
        } else {
            return greeting
        }
    }

}



