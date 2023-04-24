//
//  Int+Extensions.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 15.04.2023.
//

extension Int {
    func daysString() -> String {
        switch self % 10 {
            
        case 1 where self != 11:
            return "день"
            
        case 2...4 where (self / 10) % 10 != 1:
            return "дня"
            
        default:
            return "дней"
        }
    }
}
