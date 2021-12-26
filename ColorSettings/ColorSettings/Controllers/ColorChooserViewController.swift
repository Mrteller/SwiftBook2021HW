//
//  ColorChooserViewController.swift
//  ColorChooser
//
//  Created by  Paul on 10.12.2021.
//

import UIKit

class ColorChooserViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - @IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var colorPanelStackView: UIStackView!
    @IBOutlet weak var colorDisplay: UIView!
    @IBOutlet weak var hexTextField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var rgbStackView: UIStackView!
    
    @IBOutlet weak var redValueLabel: UILabel!
    @IBOutlet weak var greenValueLabel: UILabel!
    @IBOutlet weak var blueValueLabel: UILabel!
    
    @IBOutlet weak var redValueTextField: UITextField!
    @IBOutlet weak var greenValueTextField: UITextField!
    @IBOutlet weak var blueValueTextField: UITextField!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var hsbStackView: UIStackView!
    
    @IBOutlet weak var hueValueLabel: UILabel!
    @IBOutlet weak var saturationValueLabel: UILabel!
    @IBOutlet weak var brightnesValueLabel: UILabel!
    
    @IBOutlet weak var hueSlider: UISlider!
    @IBOutlet weak var saturationSlider: UISlider!
    @IBOutlet weak var brightnesSlider: UISlider!
    
    @IBOutlet weak var stackBottomToSafeConstaint: NSLayoutConstraint!
    
    // MARK: - Lificycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.addConstraint(segmentedControlMinHeightConstraint)
        redValueLabel.addConstraint(rgbLabelMinWidthConstraint)
        hueValueLabel.addConstraint(hsbLabelMinWidthConstraint)
        hexTextField.delegate = self
        
        colorDisplay.backgroundColor = UIColor(ciColor: color)
        hexTextField.text = UIColor.toHex(r: color.red, g: color.green, b: color.blue)
        updateSliders(from: hexTextField.text)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setDynamicFontSizeAndConstraints()
        view.layoutSubviews()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setDynamicFontSizeAndConstraints), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        titleLabel.applyGradientWith(colors: [.red, .orange])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.setBackgroundColor(colorDisplay.backgroundColor ?? .systemBackground)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//        if traitCollection.verticalSizeClass == .compact {
//            stackBottomToSafeConstaint.constant = 16 // FIXME: replace `magic numbers`
//        } else {
//            // FIXME: calculte
//            stackBottomToSafeConstaint.constant = view.bounds.height - titleLabel.frame.height - colorPanelStackView.frame.height
//            print(stackBottomToSafeConstaint.constant)
//        }
//    }
    
    // MARK: - @IBActions
    
    @IBAction func colorspaceSegmentedControlValueChanged() {
        updateSliders(from: hexTextField.text)
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            hsbStackView.isHidden = true
            rgbStackView.isHidden = false
        case 1:
            rgbStackView.isHidden = true
            hsbStackView.isHidden = false
        default:
            break
        }
    }
    
    @IBAction func rgbSliderValueChanged(_ sender: UISlider) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            (red, green, blue) = (CGFloat(redSlider.value), CGFloat(greenSlider.value), CGFloat(blueSlider.value))
            hexTextField.text = UIColor.toHex(r: red, g: green, b: blue)
        case 1:
            (hue, saturation, brightness) = (CGFloat(hueSlider.value), CGFloat(saturationSlider.value), CGFloat(brightnesSlider.value))
            hexTextField.text = UIColor.toHex(h: hue, s: saturation, b: brightness)
        default:
            break
        }
        
        updateColorDisplay(from: hexTextField.text)
        updateSliders(from: hexTextField.text) // setting slider value does not fire `rgbSliderValueChanged()`, so it is OK
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(string)
        
        switch textField {
        case hexTextField:
            var containsInadmissible = false
            let cs = CharacterSet(charactersIn: "0"..."9").union(CharacterSet(charactersIn: "a"..."f")).union(CharacterSet(charactersIn: "A"..."F")).union(CharacterSet(charactersIn: "#"))
            
            containsInadmissible = string.contains { ch in !cs.contains(ch.unicodeScalars.first!) }
            if var text = textField.text, let range = Range(range, in: text) {
                text.replaceSubrange(range, with: string)
                if updateColorDisplay(from: text) {
                    textField.textColor = .label
                } else {
                    textField.textColor = .systemGray
                }
                updateSliders(from: text)
            }
            
            return !containsInadmissible
            
        case redValueTextField, greenValueTextField, blueValueTextField:
            var containsInadmissible = false
            let cs = CharacterSet(charactersIn: "0"..."9").union(CharacterSet(charactersIn: ".,"))
            containsInadmissible = string.contains { ch in !cs.contains(ch.unicodeScalars.first!) }
            if var text = textField.text, let range = Range(range, in: text) {
                text.replaceSubrange(range, with: string)
                textField.text = text.replacingOccurrences(of: ",", with: ".")
            }
            return containsInadmissible
        default:
            return true
        }

    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case hexTextField:
            if Set([6, 8]).contains(textField.text?.replacingOccurrences(of: "#", with: "").count) {
                textField.resignFirstResponder()
                return true
            }
             return false
        case redValueTextField, greenValueTextField, blueValueTextField:
            //return colorValueChanged(by: textField)
            return true
        default:
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        colorValueChanged(by: textField)
    }
    
    // MARK: - Public vars
    
    var color = CIColor(color: UIColor.systemBackground)
    
    weak var delegate: ColorizedProtocol?
    
    // MARK: - Private vars
    
    private let fontMetrics = UIFontMetrics(forTextStyle: .body)
    private let screenMultiplier: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 2 : 1
    private lazy var segmentedControlFontSize: CGFloat = 22 * screenMultiplier
    private lazy var hexTVFontSize: CGFloat = 24 * screenMultiplier
    private lazy var labelFontSize: CGFloat = 20 * screenMultiplier
    private var red: CGFloat = 0.5;
    private var green: CGFloat = 0.5;
    private var blue: CGFloat = 0.5;
    private var alpha: CGFloat = 1
    private var hue: CGFloat = 0.5;
    private var saturation: CGFloat = 0.5;
    private var brightness: CGFloat = 0.5;
    private lazy var segmentedControlMinHeightConstraint = NSLayoutConstraint(item: segmentedControl!, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .height, multiplier: 1, constant: segmentedControlFontSize)
    private lazy var rgbLabelMinWidthConstraint = NSLayoutConstraint(item: redValueLabel!, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .width, multiplier: 1, constant: redValueLabel.font.xHeight * 3)
    private lazy var hsbLabelMinWidthConstraint = NSLayoutConstraint(item: hueValueLabel!, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .width, multiplier: 1, constant: hueValueLabel.font.xHeight * 3)
 
    // MARK: - Private methods
    
    @discardableResult
    private func updateColorDisplay(from hex: String?) -> Bool {
        if let hex = hex, let color = UIColor(hex: hex) {
            colorDisplay.backgroundColor = color
            colorDisplay.startShimmering()
            return true
        } else {
            colorDisplay.backgroundColor = .clear
            return false
        }
    }
    
    private func updateSliders(from hex: String?) {
        if let hex = hex, let color = UIColor(hex: hex) {
            color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            (redSlider.value, greenSlider.value, blueSlider.value) = (Float(red), Float(green), Float(blue))
            [redSlider, greenSlider, blueSlider].forEach{ $0?.isEnabled = true }
            redValueLabel.text = redSlider.value.fratcionDigitis(2)
            greenValueLabel.text = greenSlider.value.fratcionDigitis(2)
            blueValueLabel.text = blueSlider.value.fratcionDigitis(2)
            redValueTextField.text = redSlider.value.fratcionDigitis(2)
            greenValueTextField.text = greenSlider.value.fratcionDigitis(2)
            blueValueTextField.text = blueSlider.value.fratcionDigitis(2)
            
            
            color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
            (hueSlider.value, saturationSlider.value, brightnesSlider.value) = (Float(hue), Float(saturation), Float(brightness))
            [hueSlider, greenSlider, brightnesSlider].forEach{ $0?.isEnabled = true }
            hueValueLabel.text = hueSlider.value.fratcionDigitis(2)
            saturationValueLabel.text = saturationSlider.value.fratcionDigitis(2)
            brightnesValueLabel.text = brightnesSlider.value.fratcionDigitis(2)
            
        } else {
            [redSlider, greenSlider, blueSlider].forEach{ $0?.isEnabled = false }
            [redValueLabel, greenValueLabel, blueValueLabel].forEach{ $0?.text = "?"}
            
            [hueSlider, saturationSlider, brightnesSlider].forEach{ $0?.isEnabled = false }
            [hueValueLabel, saturationValueLabel, brightnesValueLabel].forEach{ $0?.text = "?"}
        }
    }
    
    
    @discardableResult
    private func colorValueChanged(by textField: UITextField) -> Bool {
        guard let correspondingSlider = view.allSubViewsOf(type: UISlider.self).first(where: { $0.tag == textField.tag }) else { return false }
        if let value = Float(textField.text ?? "0"), (value >= 0) && (value <= 1)  {
            textField.text = value.fratcionDigitis(2)
            correspondingSlider.value = value //.clamp(lowerBound: 0, upperBound: 1)
            rgbSliderValueChanged(redSlider) // TODO: refactor
            return true
        } else {
            textField.text = correspondingSlider.value.fratcionDigitis(2)
            showAlert(title: "Wrong input", message: "Parameter must be between 0 and 1")
        }
        return false
    }
    
    private func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func adjustFonts(`in` view: UIView) {
        for view in view.subviews {
            if let label = view as? UILabel {
                // label.font = fontMetrics.scaledFont(for: label.font)
                label.font = fontMetrics.scaledFont(for: label.font.withSize(labelFontSize +  20 * CGFloat(label.tag)))
                label.layer.contentsGravity = .center
            } else if let textField = view as? UITextField {
                if textField == hexTextField {
                    textField.font = fontMetrics.scaledFont(for: textField.font?.withSize(hexTVFontSize) ?? .systemFont(ofSize: hexTVFontSize))
                } else {
                    textField.font = fontMetrics.scaledFont(for: (textField.font?.withSize(labelFontSize)) ?? .systemFont(ofSize: labelFontSize))
                }
            } else {
                // Recursive loop through subview
                adjustFonts(in: view)
            }
        }
    }
    
    private func adjustConstraints() {
        
        let minWidthForLabel = "0.000".size(withAttributes: [.font : redValueLabel.font ?? .systemFont(ofSize: labelFontSize)]).width // TODO: proper calculation

        redValueTextField.widthAnchor.constraint(equalToConstant: minWidthForLabel).isActive = true

        rgbLabelMinWidthConstraint.constant = minWidthForLabel
        hsbLabelMinWidthConstraint.constant = minWidthForLabel
        
        let segmentedControlFont = fontMetrics.scaledFont(for: UIFont.systemFont(ofSize: segmentedControlFontSize))
        segmentedControl.setTitleTextAttributes([.font : segmentedControlFont], for: .normal)
        segmentedControlMinHeightConstraint.constant = segmentedControlFont.pointSize
        
    }
    
    @objc private func setDynamicFontSizeAndConstraints() {
        adjustFonts(in: view)
        adjustConstraints()
    }
    
    @objc private func keyboardWillShow(_ notification: Notification?) {
        if let keyboardSize = (notification?.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size {
            UIView.animate(withDuration: 0.3, animations: {
                var frame = self.view.frame
                frame.origin.y = -keyboardSize.height / 2
                self.view.frame = frame
            })
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification?) {
        UIView.animate(withDuration: 0.3, animations: {
            var frame = self.view.frame
            frame.origin.y = 0.0
            self.view.frame = frame
        })
    }
    
}

// MARK: - Rounding

extension BinaryFloatingPoint {
    func fratcionDigitis(_ max: Int, _ min: Int = 0, roundingMode: NumberFormatter.RoundingMode = .halfEven) -> String {
        let number = NumberFormatter()
        number.decimalSeparator = "." // TODO: handle ","
        number.roundingMode = roundingMode
        number.maximumFractionDigits = max
        number.minimumFractionDigits = min
        return number.string(for: self) ?? ""
    }
}


