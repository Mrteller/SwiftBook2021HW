//
//  ViewController.swift
//  ColorSettings
//
//  Created by  Paul on 23.12.2021.
//

import UIKit

protocol ColorizedProtocol{
    func setBackgroundColor(_ color: UIColor)
}

class HomeViewController: UIViewController, ColorizedProtocol {
    
    // MARK: - @IBOutlets
    
    // MARK: - Public vars
    
    // MARK: - Private vars
    
    // MARK: - Initializers
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - @IBActions
    
    // MARK: - Public funcs
    
    func setBackgroundColor(_ color: UIColor) {
        view.backgroundColor = color
    }
    
    // MARK: - Private funcs
    

    




}

