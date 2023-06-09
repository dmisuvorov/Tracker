//
//  Tracker.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 04.04.2023.
//
import UIKit

struct Tracker: Equatable {
    let id: UUID
    let name: String
    let color: String
    let emoji: String
    let isPinned: Bool
    let day: Set<Day>?
}
