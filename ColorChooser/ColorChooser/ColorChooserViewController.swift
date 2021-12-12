//
//  ColorChooserViewController.swift
//  ColorChooser
//
//  Created by  Paul on 10.12.2021.
//

import UIKit

class ColorChooserViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - @IBOutlets
    
    @IBOutlet weak var colorDisplay: UIView!
    @IBOutlet weak var hexTextField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var rgbStackView: UIStackView!
    
    @IBOutlet weak var redValueLabel: UILabel!
    @IBOutlet weak var greenValueLabel: UILabel!
    @IBOutlet weak var blueValueLabel: UILabel!
    
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
        
        updateSliders(from: hexTextField.text ?? "")
        
        segmentedControl.addConstraint(segmentedControlMinHeightConstraint)

        redValueLabel.addConstraint(rgbLabelMinWidthConstraint)
        hueValueLabel.addConstraint(hsbLabelMinWidthConstraint)
        
        colorDisplay.backgroundColor = UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        
        hexTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(setDynamicFontSizeAndConstraints), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setDynamicFontSizeAndConstraints()
        traitCollectionDidChange(nil) // TODO: extract to separate func
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.verticalSizeClass == .compact {
            stackBottomToSafeConstaint.constant = 16 // FIXME: replace `magic numbers`
        } else {
            stackBottomToSafeConstaint.constant = view.bounds.height / 3
        }
    }
    
    // MARK: - @IBActions
    
    @IBAction func colorspaceSegmentedControlValueChanged() {
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
            (r, g, b) = (CGFloat(redSlider.value), CGFloat(greenSlider.value), CGFloat(blueSlider.value))
            hexTextField.text = UIColor.toHex(r: r, g: g, b: b)
        case 1:
            (h, s, br) = (CGFloat(hueSlider.value), CGFloat(saturationSlider.value), CGFloat(brightnesSlider.value))
            hexTextField.text = UIColor.toHex(h: h, s: s, b: br)
        default:
            break
        }
        
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
    
    private let fontMetrics = UIFontMetrics(forTextStyle: .body)
    private let screenMultiplier: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 2 : 1
    private lazy var segmentedControlFontSize: CGFloat = 22 * screenMultiplier
    private lazy var hexTVFontSize: CGFloat = 24 * screenMultiplier
    private lazy var labelFontSize: CGFloat = 20 * screenMultiplier
    private var r: CGFloat = 0.5; private var g: CGFloat = 0.5; private var b: CGFloat = 0.5; private var a: CGFloat = 1
    private var h: CGFloat = 0.5; private var s: CGFloat = 0.5; private var br: CGFloat = 0.5;
    private lazy var segmentedControlMinHeightConstraint = NSLayoutConstraint(item: segmentedControl!, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .height, multiplier: 1, constant: segmentedControlFontSize)
    private lazy var rgbLabelMinWidthConstraint = NSLayoutConstraint(item: redValueLabel!, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .width, multiplier: 1, constant: redValueLabel.font.xHeight * 3)
    private lazy var hsbLabelMinWidthConstraint = NSLayoutConstraint(item: hueValueLabel!, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .width, multiplier: 1, constant: hueValueLabel.font.xHeight * 3)
 
    // MARK: - Private methods
    
    @discardableResult
    private func updateColorDisplay(from hex: String?) -> Bool {
        if let hex = hex, let color = UIColor(hex: hex) {
            colorDisplay.backgroundColor = color
            return true
        } else {
            colorDisplay.backgroundColor = .clear
            return false
        }
    }
    
    private func updateSliders(from hex: String) {
        if let color = UIColor(hex: hex) {
            color.getRed(&r, green: &g, blue: &b, alpha: &a)
            (redSlider.value, greenSlider.value, blueSlider.value) = (Float(r), Float(g), Float(b))
            [redSlider, greenSlider, blueSlider].forEach{ $0?.isEnabled = true }
            redValueLabel.text = redSlider.value.fratcionDigitis(2)
            greenValueLabel.text = greenSlider.value.fratcionDigitis(2)
            blueValueLabel.text = blueSlider.value.fratcionDigitis(2)
            
            color.getHue(&h, saturation: &s, brightness: &br, alpha: &a)
            (hueSlider.value, saturationSlider.value, brightnesSlider.value) = (Float(h), Float(s), Float(br))
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
        
           colorDisplay.startShimmering()

    }
    
    private func adjustFonts(`in` view: UIView) {
        for view in view.subviews {
            if let label = view as? UILabel {
                // label.font = fontMetrics.scaledFont(for: label.font)
                label.font = fontMetrics.scaledFont(for: UIFont.preferredFont(forTextStyle: .headline).withSize(labelFontSize))
            } else if let textField = view as? UITextField {
                textField.font = fontMetrics.scaledFont(for: .systemFont(ofSize: hexTVFontSize))
            } else {
                // Recursive loop through subview
                adjustFonts(in: view)
            }
        }
    }
    
    private func adjustConstraints() {
        rgbLabelMinWidthConstraint.constant = NSString("0.00").size(withAttributes: [.font : redValueLabel.font!]).width // TODO: proper calculation
        hsbLabelMinWidthConstraint.constant = NSString("0.00").size(withAttributes: [.font : hueValueLabel.font!]).width
        
        let segmentedControlFont = fontMetrics.scaledFont(for: UIFont.systemFont(ofSize: segmentedControlFontSize))
        segmentedControl.setTitleTextAttributes([.font : segmentedControlFont], for: .normal)
        segmentedControlMinHeightConstraint.constant = segmentedControlFont.pointSize
        
    }
    
    @objc private func setDynamicFontSizeAndConstraints() {
        adjustFonts(in: view)
        adjustConstraints()
    }
    
}

// MARK: - Rounding

extension BinaryFloatingPoint {
    func fratcionDigitis(_ max: Int, _ min: Int = 0, roundingMode: NumberFormatter.RoundingMode = .halfEven) -> String {
        let number = NumberFormatter()
        number.roundingMode = roundingMode
        number.maximumFractionDigits = max
        number.minimumFractionDigits = min
        return number.string(for: self) ?? ""
    }
}


