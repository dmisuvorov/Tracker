//
//  UIColor+Common.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 01.04.2023.
//
import UIKit

enum DSColor: String {
    case blue = "Blue"
    case gray = "Gray"
    case red = "Red"
    
    case dayBackground = "Background [day]"
    case dayBlack = "Black [day]"
    case dayWhite = "White [day]"
}

extension UIColor {
    static func dsColor(dsColor: DSColor) -> UIColor {
        UIColor(named: dsColor.rawValue) ?? .clear
    }

    static func colorFromHex(hexString: String) -> UIColor? {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        
        guard hex.count == 6 else { return nil }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
