//
//  String+Common.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 17.04.2023.
//
import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
