//
//  Date+Common.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 17.04.2023.
//

import UIKit

extension Date {
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
        
    var endOfDay: Date {
        let calendar = Calendar.current
        let startOfNextDay = calendar.date(byAdding: .day, value: 1, to: self.startOfDay) ?? Date()
        return calendar.date(byAdding: .second, value: -1, to: startOfNextDay) ?? Date()
    }
    
    static func ==(lhs: Date, rhs: Date) -> Bool {
        let calendar = Calendar.current
        let comparisonResult = calendar.compare(lhs, to: rhs, toGranularity: Calendar.Component.day)
        return comparisonResult == ComparisonResult.orderedSame
    }
        
    static func <(lhs: Date, rhs: Date) -> Bool {
        let calendar = Calendar.current
        let comparisonResult = calendar.compare(lhs, to: rhs, toGranularity: Calendar.Component.day)
        return comparisonResult == ComparisonResult.orderedAscending
    }
        
    static func >(lhs: Date, rhs: Date) -> Bool {
        let calendar = Calendar.current
        let comparisonResult = calendar.compare(lhs, to: rhs, toGranularity: Calendar.Component.day)
        return comparisonResult == ComparisonResult.orderedDescending
    }
    
    static func <=(lhs: Date, rhs: Date) -> Bool {
        return lhs < rhs || lhs == rhs
    }
    
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
