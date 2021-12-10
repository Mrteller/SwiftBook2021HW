//
//  ViewController.swift
//  ColorChooser
//
//  Created by  Paul on 10.12.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var colorDisplay: UIView!
    @IBOutlet weak var hexTextField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var redValueLabel: UILabel!
    @IBOutlet weak var greenValueLabel: UILabel!
    @IBOutlet weak var blueValueLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let segmentedControlFontSize: CGFloat = 30
        segmentedControl.setTitleTextAttributes([.font : UIFont.systemFont(ofSize: segmentedControlFontSize)], for: .normal)
        segmentedControl.addConstraint(NSLayoutConstraint(item: segmentedControl!, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .height, multiplier: 1, constant: segmentedControlFontSize))
        
        colorDisplay.backgroundColor = UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
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
        (r, g, b) = (r.clamp(lowerBound: 0, upperBound: 1), g.clamp(lowerBound: 0, upperBound: 1), b.clamp(lowerBound: 0, upperBound: 1))
        //print("R:\(r) G:\(g) B:\(b)")
        let value = CGFloat(sender.value)
        let valueDescription = sender.value.fratcionDigitis(2)
        switch sender.tag {
        case 1:
            redValueLabel.text = valueDescription
            r = value
        case 2:
            greenValueLabel.text = valueDescription
            g = value
        case 3:
            blueValueLabel.text = valueDescription
            b = value
        default:
            break
        }
        
        colorDisplay.backgroundColor = UIColor(displayP3Red: r, green: g, blue: b, alpha: 1)
        hexTextField.text = colorDisplay.backgroundColor?.toHex()
    }
    
    // MARK: - Private vars
    var r: CGFloat = 0.5; var g: CGFloat = 0.5; var b: CGFloat = 0.5; var a: CGFloat = 1

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


