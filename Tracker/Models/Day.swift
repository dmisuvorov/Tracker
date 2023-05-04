//
//  WeekDay.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 04.04.2023.
//

enum Day: String, CaseIterable, Codable {
    case mon = "Понедельник"
    case tue = "Вторник"
    case wed = "Среда"
    case thu = "Четверг"
    case fri = "Пятница"
    case sat = "Суббота"
    case sun = "Воскресенье"
}

extension Set where Element == Day {
    
    func toShortDescription() -> String {
        if self == Set(Day.allCases) { return "Каждый день" }
        
        return self.sorted { $0.num < $1.num }
            .map { $0.shortDescription }
            .joined(separator: ", ")
    }
}

private extension Day {
    var shortDescription: String {
        let description: String
        switch self {
        case .mon:
            description = "Пн"
        case .tue:
            description = "Вт"
        case .wed:
            description = "Ср"
        case .thu:
            description = "Чт"
        case .fri:
            description = "Пт"
        case .sat:
            description = "Сб"
        case .sun:
            description = "Вс"
        }
        
        return description
    }
    
    var num: Int {
        let num: Int
        switch self {
        case .mon:
            num = 1
        case .tue:
            num = 2
        case .wed:
            num = 3
        case .thu:
            num = 4
        case .fri:
            num = 5
        case .sat:
            num = 6
        case .sun:
            num = 7
        }
        
        return num
    }
}
