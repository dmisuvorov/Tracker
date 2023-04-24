//
//  TrackersPresenter.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 17.04.2023.
//
import UIKit

final class TrackersPresenter {
    
    private weak var trackersView: TrackersViewProtocol? = nil
    private var currentDate: Date = Date()
    private var completedTrackers: Set<TrackerRecord> = []
    private let trackersRepository = TrackersRepository.shared
    
    init(trackersView: TrackersViewProtocol) {
        self.trackersView = trackersView
    }
    
    func showCurrentTrackers() {
        let currentDay = currentDate.dayOfWeek()
        let currentTrackers = trackersRepository.getTrackersByFilter { tracker in
            tracker.day?.contains(currentDay) ?? true
        }
        if currentTrackers.isEmpty {
            trackersView?.showEmptyPlaceholder()
            return
        }
        trackersView?.showCurrentTrackers(categories: currentTrackers, completedTrackers: completedTrackers)
    }
    
    func searchTrackersByName(name: String) {
        let currentDay = currentDate.dayOfWeek()
        let currentTrackers = trackersRepository.getTrackersByFilter { tracker in
            tracker.day?.contains(currentDay) ?? true && tracker.name.contains(name)
        }
        if currentTrackers.isEmpty {
            trackersView?.showEmptySearchPlaceholder()
            return
        }
        trackersView?.showCurrentTrackers(categories: currentTrackers, completedTrackers: completedTrackers)
    }
    
    func updateCurrentDate(date: Date) {
        currentDate = date
    }
    
    func completeTracker(trackerId: UUID) {
        let completeTracker = TrackerRecord(id: trackerId, date: currentDate)
        if completedTrackers.contains(completeTracker) {
            completedTrackers.remove(completeTracker)
        } else {
            completedTrackers.insert(completeTracker)
        }
    }
    
    func onBindTrackerCell(cell: TrackerViewCell, tracker: Tracker) {
        let isCurrentTrackerDoneInCurrentDate = completedTrackers.filter { $0.id == tracker.id && $0.date == currentDate }.count > 0
        let countOfCompleted = completedTrackers.filter { $0.id == tracker.id }.count
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
