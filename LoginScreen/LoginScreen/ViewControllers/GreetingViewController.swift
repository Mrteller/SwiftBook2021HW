//
//  GreetingViewController.swift
//  LoginScreen
//
//  Created by  Paul on 14.12.2021.
//

import UIKit

class GreetingViewController: UIViewController {
    
    // MARK: - @IBOutlets
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var userGreetingLabel: UILabel!
    
    // MARK: - Public vars
    
    var userName: String? {
        didSet {
            userGreetingLabel?.text = userName
        }
    }
    
    var avatarURL: URL? {
        didSet {
            avatarImageView?.image = nil
            if view.window != nil { // if we're on screen
                fetchImage()        // then fetch image
            }
        }
    }
    
    // MARK: - Private vars
    
    // MARK: - Lifecycle methods

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if userGreetingLabel.text != userName {
            userGreetingLabel.text = userName
        }
        
        if avatarImageView?.image == nil { // about to appear on screen so, if needed:
            fetchImage()
        }
    }

    // MARK: - Private funcs
    
    private func fetchImage() {
        // TODO: replace magic number with constants in some namespace
        if let url = avatarURL {
            avatarImageView?.image = UIImage(systemName: "person")
            spinner.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: url)
                if let imageData = urlContents, url == self?.avatarURL {
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 0.5, delay: 0,
                                       options: []) {
                            self?.avatarImageView?.alpha = 0
                        } completion: { _ in
                            UIView.animate(withDuration: 0.5) {
                                self?.avatarImageView?.alpha = 1
                                self?.avatarImageView?.image = UIImage(data: imageData)
                            }
                        }

                        self?.spinner.stopAnimating()
                    }
                }
            }
        }
    }
    
//    private func greetUser(user name: String?, greeting: String = "Hello") -> String {
//        if let name = name, !name.isEmpty {
//            return "\(greeting), \(name)"
//        } else {
//            return greeting
//        }
//    }

}



