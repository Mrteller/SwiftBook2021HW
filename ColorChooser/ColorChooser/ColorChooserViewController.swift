//
//  ColorChooserViewController.swift
//  ColorChooser
//
//  Created by  Paul on 10.12.2021.
//

import UIKit

class ColorChooserViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var colorDisplay: UIView!
    @IBOutlet weak var hexTextField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var redValueLabel: UILabel!
    @IBOutlet weak var greenValueLabel: UILabel!
    @IBOutlet weak var blueValueLabel: UILabel!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let segmentedControlFontSize: CGFloat = 30
        segmentedControl.setTitleTextAttributes([.font : UIFont.systemFont(ofSize: segmentedControlFontSize)], for: .normal)
        segmentedControl.addConstraint(NSLayoutConstraint(item: segmentedControl!, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .height, multiplier: 1, constant: segmentedControlFontSize))
        
        colorDisplay.backgroundColor = UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        
        hexTextField.delegate = self
    }
    
    override func viewDidLayoutSubviews() {

    }
    
    @IBAction func rgbSliderValueChanged(_ sender: UISlider) {

//        colorDisplay.backgroundColor?.getRed(&r, green: &g, blue: &b, alpha: &a)
//        if let components = colorDisplay.backgroundColor?.cgColor.components {
//            r = components[0]; g = components[1]; b = components[2]
//        }
//        let rgba = try! UIColor.RGBA(colorDisplay.backgroundColor!)
//        r = rgba.red; g = rgba.green; b = rgba.blue
        
        // print("R:\(r) G:\(g) B:\(b)")
        // (r, g, b) = (r.clamp(lowerBound: 0, upperBound: 1), g.clamp(lowerBound: 0, upperBound: 1), b.clamp(lowerBound: 0, upperBound: 1))
        //print("R:\(r) G:\(g) B:\(b)")
//        let value = CGFloat(sender.value)
//        let valueDescription = sender.value.fratcionDigitis(2)
//        switch sender.tag {
//        case 1:
//            redValueLabel.text = valueDescription
//            r = value
//        case 2:
//            greenValueLabel.text = valueDescription
//            g = value
//        case 3:
//            blueValueLabel.text = valueDescription
//            b = value
//        default:
//            break
//        }
        (r, g, b) = (CGFloat(redSlider.value), CGFloat(greenSlider.value), CGFloat(blueSlider.value))
        
        hexTextField.text = UIColor.rgbToHex(r: r, g: g, b: b)
        updateColorDisplay(from: hexTextField.text)
        updateSliders(from: hexTextField.text ?? "") // setting slider value does not fire `rgbSliderValueChanged()`, so it is OK

    }
    // MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(string)
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
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if Set([6, 8]).contains(textField.text?.replacingOccurrences(of: "#", with: "").count) {
            textField.resignFirstResponder()
        }
        return true
    }
    // MARK: - Private vars
    var r: CGFloat = 0.5; var g: CGFloat = 0.5; var b: CGFloat = 0.5; var a: CGFloat = 1
    
    // MARK: - Private methods
    @discardableResult
    func updateColorDisplay(from hex: String?) -> Bool {
        if let hex = hex, let color = UIColor(hex: hex) {
            colorDisplay.backgroundColor = color
            return true
        } else {
            colorDisplay.backgroundColor = .clear
            return false
        }
    }
    
    func updateSliders(from hex: String) {
        if let color = UIColor(hex: hex) {
            color.getRed(&r, green: &g, blue: &b, alpha: &a)
            (redSlider.value, greenSlider.value, blueSlider.value) = (Float(r), Float(g), Float(b))
            [redSlider, greenSlider, blueSlider].forEach({ $0?.isEnabled = true })
            redValueLabel.text = redSlider.value.fratcionDigitis(2)
            greenValueLabel.text = greenSlider.value.fratcionDigitis(2)
            blueValueLabel.text = blueSlider.value.fratcionDigitis(2)
        } else {
            [redSlider, greenSlider, blueSlider].forEach{ $0?.isEnabled = false }
            [redValueLabel, greenValueLabel, blueValueLabel].forEach{ $0?.text = "?"}
        }
    }
    
}

// MARK: rounding

extension BinaryFloatingPoint {
    func fratcionDigitis(_ max: Int, _ min: Int = 0, roundingMode: NumberFormatter.RoundingMode = .halfEven) -> String {
        let number = NumberFormatter()
        number.roundingMode = roundingMode
        number.maximumFractionDigits = max
        number.minimumFractionDigits = min
        return number.string(for: self) ?? ""
    }
}

extension Comparable {
    func clamp(lowerBound: Self, upperBound: Self) -> Self {
        return min(max(self, lowerBound), upperBound)
    }
}


