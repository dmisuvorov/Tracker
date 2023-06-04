//
//  WeekDay.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 04.04.2023.
//

enum Day: CaseIterable, Codable {
    case mon
    case tue
    case wed
    case thu
    case fri
    case sat
    case sun

    var localized: String {
        switch self {
        case .mon: return "monday".localized
        case .tue: return "tuesday".localized
        case .wed: return "wednesday".localized
        case .thu: return "thursday".localized
        case .fri: return "friday".localized
        case .sat: return "saturday".localized
        case .sun: return "sunday".localized
        }
    }
}

extension Set where Element == Day {
    
    func toShortDescription() -> String {
        if self == Set(Day.allCases) { return "everyday".localized }
        
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
            description = "mon".localized
        case .tue:
            description = "tue".localized
        case .wed:
            description = "wed".localized
        case .thu:
            description = "thu".localized
        case .fri:
            description = "fri".localized
        case .sat:
            description = "sat".localized
        case .sun:
            description = "sun".localized
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
