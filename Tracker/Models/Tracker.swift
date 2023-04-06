//
//  Tracker.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 04.04.2023.
//
import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: String
    let emoji: String
    let day: Set<Day>
}
