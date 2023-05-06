//
//  TrackersPresenter.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 17.04.2023.
//
import UIKit

final class TrackersPresenter {
    
    private weak var trackersView: TrackersViewProtocol? = nil
    private var currentSelectedDate: Date = Date()
    private var currentDate: Date = Date()
    private let trackersRepository = TrackersRepository.shared
    
    init(trackersView: TrackersViewProtocol) {
        self.trackersView = trackersView
    }
    
    func showCurrentTrackers() {
        let currentDay = currentSelectedDate.dayOfWeek()
        let currentTrackers = trackersRepository.getTrackersByFilter { tracker in
            tracker.day?.contains(currentDay) ?? true
        }
        if currentTrackers.isEmpty {
            trackersView?.showEmptyPlaceholder()
            return
        }
        trackersView?.showCurrentTrackers(
            categories: currentTrackers,
            completedTrackers: trackersRepository.completedTrackers
        )
    }
    
    func searchTrackersByName(name: String) {
        let currentDay = currentSelectedDate.dayOfWeek()
        let currentTrackers = trackersRepository.getTrackersByFilter { tracker in
            tracker.day?.contains(currentDay) ?? true && tracker.name.contains(name)
        }
        if currentTrackers.isEmpty {
            trackersView?.showEmptySearchPlaceholder()
            return
        }
        trackersView?.showCurrentTrackers(
            categories: currentTrackers,
            completedTrackers: trackersRepository.completedTrackers
        )
    }
    
    func updateCurrentDate(date: Date) {
        currentSelectedDate = date
    }
    
    func processTrackerClick(trackerId: UUID) {
        guard currentSelectedDate <= currentDate else { return }
        let completeTracker = TrackerRecord(id: trackerId, date: currentSelectedDate)
        let isNeedMarkUncomplete =
            trackersRepository.completedTrackers
                .contains(where: { record in record.id == trackerId })
        
        if isNeedMarkUncomplete {
            trackersRepository.deleteTrackerRecord(trackerRecord: completeTracker)
        } else {
            
            trackersRepository.addTrackerRecord(trackerRecord: completeTracker)
        }
    }
    
    func onBindTrackerCell(cell: TrackerViewCell, tracker: Tracker) {
        let isCurrentTrackerDoneInCurrentDate = trackersRepository.completedTrackers
            .filter { $0.id == tracker.id && $0.date == currentSelectedDate }.count > 0
        let countOfCompleted = trackersRepository.completedTrackers
            .filter { $0.id == tracker.id }.count
        let trackerViewModel = TrackerView(
            id: tracker.id,
            name: tracker.name,
            color: tracker.color,
            emoji: tracker.emoji,
            daysCompleted: "\(countOfCompleted) \(countOfCompleted.daysString())",
            isDoneInCurrentDate: isCurrentTrackerDoneInCurrentDate
        )
        trackersView?.bindTrackerViewCell(cell: cell, trackerView: trackerViewModel)
    }
}
