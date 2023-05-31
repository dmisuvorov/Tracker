//
//  TrackerDetailsView.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 30.05.2023.
//

struct TrackerDetailsView {
    let flow: TrackerDetailsFlow
    let trackerInfo: TrackerDetailsInfo
}

enum TrackerDetailsFlow {
    case create
    case edit
}

struct TrackerDetailsInfo {
    let categoryName: String?
    let type: TrackerType
    let trackerDetails: Tracker?
}
