//
//  TrackersAnalyticsRepository.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 02.06.2023.
//

final class TrackerAnalyticsRepository {
    static let shared = TrackerAnalyticsRepository()
    
    private let analyticsService = AnalyticsService.shared
    
    private let openEvent = "open"
    private let closeEvent = "close"
    private let clickEvent = "click"
    
    private let screenParamsKey = "screen"
    private let itemParamsKey = "item"
    
    private let mainScreenValue = "Main"
    
    private init() { }
    
    func sendShowTrackersScreenEvent() {
        analyticsService.sendEvent(event: openEvent, params: [screenParamsKey: mainScreenValue])
    }
    
    func sendCloseTrackersScreenEvent() {
        analyticsService.sendEvent(event: closeEvent, params: [screenParamsKey: mainScreenValue])
    }
    
    func sendAddNewTrackerEvent() {
        analyticsService.sendEvent(event: clickEvent, params: [screenParamsKey: mainScreenValue, itemParamsKey: "addTrack"])
    }
    
    func sendTrackerTapEvent() {
        analyticsService.sendEvent(event: clickEvent, params: [screenParamsKey: mainScreenValue, itemParamsKey: "track"])
    }
    
    func sendEditTrackerEvent() {
        analyticsService.sendEvent(event: clickEvent, params: [screenParamsKey: mainScreenValue, itemParamsKey: "edit"])
    }
    
    func sendDeleteTrackerEvent() {
        analyticsService.sendEvent(event: clickEvent, params: [screenParamsKey: mainScreenValue, itemParamsKey: "delete"])
    }
}
