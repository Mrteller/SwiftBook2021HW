//
//  UIColor+hex.swift
//  ColorChooser
//
//  Created by  Paul on 10.12.2021.
//

import UIKit

extension UIColor {

    // MARK: - Initialization

    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0

        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0

        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0

        } else {
            return nil
        }

        self.init(red: r, green: g, blue: b, alpha: a)
    }


    // MARK: - From UIColor to String

    func toHex(alpha: Bool = false) -> String? {
        
        var r: CGFloat = 0; var g: CGFloat = 0; var b: CGFloat = 0; var a: CGFloat = 1.0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        print("R:\(r) G:\(g) B:\(b)")
        r = round(r.clamp(lowerBound: 0, upperBound: 1) * 255)
        g = round(g.clamp(lowerBound: 0, upperBound: 1) * 255)
        b = round(b.clamp(lowerBound: 0, upperBound: 1) * 255)
        a = round(a.clamp(lowerBound: 0, upperBound: 1) * 255)
        print("R:\(r) G:\(g) B:\(b)")

        if alpha {
            return String(format: "%02lX%02lX%02lX%02lX", Int(r), Int(g), Int(b), Int(a))
        } else {
            return String(format: "%02lX%02lX%02lX", Int(r), Int(g), Int(b))
        }
    }

    static func rgbToHex(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1, alpha: Bool = false) -> String? {
        
        let red = round(r.clamp(lowerBound: 0, upperBound: 1) * 255)
        let green = round(g.clamp(lowerBound: 0, upperBound: 1) * 255)
        let blue = round(b.clamp(lowerBound: 0, upperBound: 1) * 255)
        let al = round(a.clamp(lowerBound: 0, upperBound: 1) * 255)
        print("R:\(r) G:\(g) B:\(b)")

        if alpha {
            return String(format: "%02lX%02lX%02lX%02lX", Int(red), Int(green), Int(blue), Int(al))
        } else {
            return String(format: "%02lX%02lX%02lX", Int(red), Int(green), Int(blue))
        }
    }
}

