//
//  Date+Common.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 17.04.2023.
//

import UIKit

extension Date {
    
    func dayOfWeek() -> Day {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: self)
        switch weekday {
        case 1:
            return .sun
        case 2:
            return .mon
        case 3:
            return .tue
        case 4:
            return .wed
        case 5:
            return .thu
        case 6:
            return .fri
        case 7:
            return .sat
            
        default:
            return .sun
        }
    }
}
