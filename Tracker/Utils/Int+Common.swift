//
//  Int+Extensions.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 15.04.2023.
//
import Foundation

extension Int {
    func daysString() -> String {
        return String.localizedStringWithFormat(NSLocalizedString("daysCompleted", comment: ""), self)
    }
}
