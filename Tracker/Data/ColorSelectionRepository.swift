//
//  ColorRepository.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 30.04.2023.
//
import UIKit

final class ColorSelectionRepository {
    static let shared = ColorSelectionRepository()
    
    let currentColors = [
        UIColor.colorSelection(csColor: ColorSelection.CS1),
        UIColor.colorSelection(csColor: ColorSelection.CS2),
        UIColor.colorSelection(csColor: ColorSelection.CS3),
        UIColor.colorSelection(csColor: ColorSelection.CS4),
        UIColor.colorSelection(csColor: ColorSelection.CS5),
        UIColor.colorSelection(csColor: ColorSelection.CS6),
        UIColor.colorSelection(csColor: ColorSelection.CS7),
        UIColor.colorSelection(csColor: ColorSelection.CS8),
        UIColor.colorSelection(csColor: ColorSelection.CS9),
        UIColor.colorSelection(csColor: ColorSelection.CS10),
        UIColor.colorSelection(csColor: ColorSelection.CS11),
        UIColor.colorSelection(csColor: ColorSelection.CS12),
        UIColor.colorSelection(csColor: ColorSelection.CS13),
        UIColor.colorSelection(csColor: ColorSelection.CS14),
        UIColor.colorSelection(csColor: ColorSelection.CS15),
        UIColor.colorSelection(csColor: ColorSelection.CS16),
        UIColor.colorSelection(csColor: ColorSelection.CS17),
        UIColor.colorSelection(csColor: ColorSelection.CS18)
    ]
    
    private init() { }
}

private extension UIColor {
    static func colorSelection(csColor: ColorSelection) -> UIColor {
        UIColor(named: csColor.rawValue) ?? .clear
    }
}

private enum ColorSelection: String  {
    case CS1 = "ColorSelection1"
    case CS2 = "ColorSelection2"
    case CS3 = "ColorSelection3"
    case CS4 = "ColorSelection4"
    case CS5 = "ColorSelection5"
    case CS6 = "ColorSelection6"
    case CS7 = "ColorSelection7"
    case CS8 = "ColorSelection8"
    case CS9 = "ColorSelection9"
    case CS10 = "ColorSelection10"
    case CS11 = "ColorSelection11"
    case CS12 = "ColorSelection12"
    case CS13 = "ColorSelection13"
    case CS14 = "ColorSelection14"
    case CS15 = "ColorSelection15"
    case CS16 = "ColorSelection16"
    case CS17 = "ColorSelection17"
    case CS18 = "ColorSelection18"
}
