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

    static func toHex<F: BinaryFloatingPoint>(r: F, g: F, b: F, a: F = 1, alpha: Bool = false) -> String? {
        
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
    
    static func toHex<F: BinaryFloatingPoint>(h: F, s: F, b: F) -> String? {
        var red, green, blue, i, f, p, q, t: F
        i = (h * 6).rounded(.down)
        f = h * 6 - i
        p = b * (1 - s)
        q = b * (1 - f * s)
        t = b * (1 - (1 - f) * s)
        switch h * 360 {
        case 0..<60, 360: red = b; green = t; blue = p
        case 60..<120: red = q; green = b; blue = p
        case 120..<180: red = p; green = b; blue = t
        case 180..<240: red = p; green = q; blue = b
        case 240..<300: red = t; green = p; blue = b
        case 300..<360: red = b; green = p; blue = q
        default: return nil
        }
            return String(format: "%02lX%02lX%02lX", Int(red), Int(green), Int(blue))
        }
    }

