//
//  ViewController.swift
//  LoginScreen
//
//  Created by  Paul on 13.12.2021.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - @IBOutlets

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var stackBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Private vars
    
    private let underKeyboardLayoutConstraint = UnderKeyboardLayoutConstraint()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        userNameTextField.leftViewMode = .always
        userNameTextField.leftView = imageView(for: "person", textStyle: .largeTitle)
        
        passwordTextField.leftViewMode = .always
        passwordTextField.leftView = imageView(for: "lock", textStyle: .largeTitle)
        
        underKeyboardLayoutConstraint.setup(stackBottomConstraint, view: view, minMargin: 0)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "loggedInSegue" {
            if case let .failure(reason) = authorize(login: userNameTextField.text, password: passwordTextField.text) {
                showLoginFailed(reason: reason as? String)
                return false
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let greetingVC = segue.destination as? GreetingViewController {
            greetingVC.userName = userNameTextField.text
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super .touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    // MARK: - @IBActions
    
    @IBAction func unwind(for unwindSegue: UIStoryboardSegue) {
        userNameTextField.text = ""
        passwordTextField.text = ""
    }
    @IBAction func forgotLoginButton(_ sender: UIButton) {
        showCredentials()
    }
    @IBAction func forgotPasswordButton(_ sender: UIButton) {
        showCredentials()
    }
    
    // MARK: - Public funcs
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextResponder = textField.superview?.viewWithTag(textField.tag + 1) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }

        if textField === passwordTextField {
            switch authorize(login: userNameTextField.text, password: passwordTextField.text) {
            case .success:
                performSegue(withIdentifier: "loggedInSegue", sender: self)
            case .failure(let reason):
                showLoginFailed(reason: reason.localizedDescription)
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(#function)
    }
    
    
    // MARK: - Private funcs
    /// Simulate authorizse procedure
    private func authorize(login: String?, password: String?) -> Result<String, Error> {
        switch (login, password) {
        case ("username", "password"), ("username@mail.com", "password"):
            return .success("username")
        case (_, _) where (login == nil || login?.isEmpty ?? true) :
            return .failure("Username is not provided.")
        case (_, _) where (password == nil || password?.isEmpty ?? true) :
            return .failure("Password is not provided.")
        case let (uName?, pass?):
            return .failure("Incorrect credentials:\n\(uName)\\\(pass)")
        default:
            return .failure("Failed to log in")
        }
    }
    
    private func imageView(for systemImageName: String, textStyle: UIFont.TextStyle = .largeTitle, tintColor: UIColor? = nil) -> UIImageView{
        let config = UIImage.SymbolConfiguration(textStyle: textStyle)
        let image = UIImage(systemName: systemImageName, withConfiguration: config)
        let imageView = UIImageView(image: image)
        imageView.tintColor = tintColor
        return imageView
    }
    
    private func basicAlert(title: String, message: String, style: UIAlertAction.Style = .default) -> UIAlertController {
        let alert = UIAlertController(style: .alert)
        alert.set(title: title, font: .preferredFont(forTextStyle: .title3), color: .systemRed)
        alert.set(message: message, font: .preferredFont(forTextStyle: .body))
        switch style {
        case .cancel:
            alert.addAction(title: "Cancel", style: .cancel) //.cancel action will always be at the end
        case .`default`:
            alert.addAction(title: "OK", style: .default)
        case .destructive:
            alert.addAction(title: "OK", style: .destructive)
        @unknown default:
            alert.addAction(title: "OK", style: .default)
        }
        return alert
    }
    
    private func showCredentials() {
        let alert = basicAlert(title: "Тестовая учётная запись", message: "username\npassword")
        present(alert, animated: true)
    }
    
    private func showLoginFailed(reason: String?) {
        let alert = basicAlert(title: "Login failed", message: (reason) ?? "Undefined reason", style: .cancel)
        alert.addAction(image: #imageLiteral(resourceName: "clip"), title: "Remind me", color: .purple) { [weak self] _ in
            self?.showCredentials()
        }
        present(alert, animated: true)
    }

}

// A quick way to create Errors.
extension String: LocalizedError {
    public var errorDescription: String? {
        NSLocalizedString(self, comment: "Error")
    }
}
