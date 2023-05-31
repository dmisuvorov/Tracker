//
//  ColorRepository.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 30.04.2023.
//

final class ColorSelectionRepository {
    static let shared = ColorSelectionRepository()
    
    let currentColors: [String] = [
        ColorSelection.CS1.rawValue,
        ColorSelection.CS2.rawValue,
        ColorSelection.CS3.rawValue,
        ColorSelection.CS4.rawValue,
        ColorSelection.CS5.rawValue,
        ColorSelection.CS6.rawValue,
        ColorSelection.CS7.rawValue,
        ColorSelection.CS8.rawValue,
        ColorSelection.CS9.rawValue,
        ColorSelection.CS10.rawValue,
        ColorSelection.CS11.rawValue,
        ColorSelection.CS12.rawValue,
        ColorSelection.CS13.rawValue,
        ColorSelection.CS14.rawValue,
        ColorSelection.CS15.rawValue,
        ColorSelection.CS16.rawValue,
        ColorSelection.CS17.rawValue,
        ColorSelection.CS18.rawValue
    ]
    
    private init() { }
    
    func findColorIndex(color: String) -> Int? {
        return currentColors.firstIndex(of: color)
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
