//
//  ViewController.swift
//  ColorSettings
//
//  Created by  Paul on 23.12.2021.
//

import UIKit

protocol ColorizedProtocol: AnyObject {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let colorChooserVC = segue.destination as? ColorChooserViewController {
            colorChooserVC.color = CIColor(color: view.backgroundColor ?? .systemBackground)
            colorChooserVC.delegate = self
        }
    }
    
    // MARK: - @IBActions
    
    // MARK: - Public funcs
    
    func setBackgroundColor(_ color: UIColor) {
        view.backgroundColor = color
    }
    
    // MARK: - Private funcs
    

    




}

