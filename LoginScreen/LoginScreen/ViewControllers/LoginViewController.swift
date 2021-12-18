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
    
    private var person: Person?
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
            tryToLogin()
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let greetingVC = segue.destination.allContentControllersOf(type: GreetingViewController.self).first {
            greetingVC.userName = person?.name
            greetingVC.avatarURL = person?.avatarURL
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
    @IBAction func forgotLoginOrPasswordButton(_ sender: UIButton) {
        showCredentials(tag: sender.tag)
    }

    
    // MARK: - Public funcs
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextResponder = textField.superview?.viewWithTag(textField.tag + 1) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        if textField === passwordTextField, tryToLogin() {
            performSegue(withIdentifier: "loggedInSegue", sender: self)
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setReturnKeyState(for: textField, isEnabled: validateInput(textField.text), delay: 0.1) // A bit hacky it needs delay here
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if var text = textField.text, let range = Range(range, in: text) {
            text.replaceSubrange(range, with: string)
            setReturnKeyState(for: textField, isEnabled: validateInput(text))
        }
        return true
    }
    
    
    // MARK: - Private funcs
    
    @discardableResult
    private func tryToLogin() -> Bool {
        switch Session.getPerson(login: userNameTextField.text, password: passwordTextField.text) {
        case .success(let person):
            self.person = person
            userNameTextField.text = ""
            passwordTextField.text = ""
            return true
        case .failure(let reason):
            passwordTextField.text = ""
            showLoginFailed(reason: reason.localizedDescription)
            return false
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
    
    private func showCredentials(tag: Int = 0) {
        let alert: UIAlertController
        switch tag {
        case 1:
            alert = basicAlert(title: "Test login", message: Credentials.default.login)
        case 2:
            alert = basicAlert(title: "Test password", message: Credentials.default.password)
        default:
            alert = basicAlert(title: "Test credentials", message: Credentials.default.description)
        }
        
        present(alert, animated: true)
    }
    
    private func showLoginFailed(reason: String?) {
        let alert = basicAlert(title: "Login failed", message: (reason) ?? "Undefined reason", style: .cancel)
        alert.addAction(image: #imageLiteral(resourceName: "clip"), title: "Remind me", color: .purple) { [weak self] _ in
            self?.showCredentials()
        }
        present(alert, animated: true)
    }
    
    // sample condition checker
    private func validateInput(_ string: String?) -> Bool {
        (string?.count ?? 0) > 3
    }

}

// A quick way to create Errors.
extension String: LocalizedError {
    public var errorDescription: String? {
        NSLocalizedString(self, comment: "Error")
    }
}


extension UITextFieldDelegate {
    func setReturnKeyState(for textField: UITextField, isEnabled: Bool, delay: Double? = nil) {
        textField.enablesReturnKeyAutomatically = false
        if textField.delegate != nil {
            if let delay = delay {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    textField.setValue(isEnabled, forKeyPath: "inputDelegate.returnKeyEnabled")
                }
            } else {
                textField.setValue(isEnabled, forKeyPath: "inputDelegate.returnKeyEnabled")
            }
        }
    }
}
