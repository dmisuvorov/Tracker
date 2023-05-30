//
//  TrackerDetailsView.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 30.05.2023.
//

struct TrackerDetailsView {
    let flow: TrackerDetailsFlow
    let type: TrackerType
}

enum TrackerDetailsFlow {
    case create
    case edit
}

