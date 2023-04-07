//
//  UIColor+Common.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 01.04.2023.
//
import UIKit

enum DSColor: String {
    case blue = "Blue"
    
    case dayBlack = "Black [day]"
    case dayWhite = "White [day]"
}

extension UIColor {
    static func dsColor(dsColor: DSColor) -> UIColor {
        UIColor(named: dsColor.rawValue) ?? .clear
    }
}
