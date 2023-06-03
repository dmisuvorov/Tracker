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
    private let trackersAnalyticsRepository = TrackerAnalyticsRepository.shared
    
    init(trackersView: TrackersViewProtocol) {
        self.trackersView = trackersView
    }
    
    func onViewDidLoad() {
        trackersAnalyticsRepository.sendShowTrackersScreenEvent()
    }
    
    func onViewDidDisappear() {
        trackersAnalyticsRepository.sendCloseTrackersScreenEvent()
    }
    
    func onAddNewTrackerClick() {
        trackersAnalyticsRepository.sendAddNewTrackerEvent()
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
        let resultTrackers = sortTrackersByPinStatus(currentTrackers: currentTrackers)
        trackersView?.showCurrentTrackers(categories: resultTrackers)
        
    }
    
    func searchTrackersByName(name: String) {
        let currentDay = currentSelectedDate.dayOfWeek()
        let searchName = name.lowercased()
        let currentTrackers = trackersRepository.getTrackersByFilter { tracker in
            tracker.day?.contains(currentDay) ?? true && tracker.name.lowercased().contains(searchName)
        }
        if currentTrackers.isEmpty {
            trackersView?.showEmptySearchPlaceholder()
            return
        }
        trackersView?.showCurrentTrackers(categories: currentTrackers)
    }
    
    func updateCurrentDate(date: Date) {
        currentSelectedDate = date
    }
    
    func pinTracker(trackerId: UUID) {
        guard let tracker = trackersRepository.getTrackerByIdOrNil(trackerId: trackerId),
                tracker.isPinned == false
        else { return }
        trackersRepository.pinTracker(tracker: tracker)
    }
    
    func unpinTracker(trackerId: UUID) {
        guard let tracker = trackersRepository.getTrackerByIdOrNil(trackerId: trackerId),
                tracker.isPinned == true
        else { return }
        trackersRepository.unpinTracker(tracker: tracker)
    }
    
    func editTracker(trackerId: UUID) {
        trackersAnalyticsRepository.sendEditTrackerEvent()
        guard let trackerDetails = trackersRepository.getTrackerDetailsInfoByIdOrNil(trackerId: trackerId) else { return }
        let trackerDetailsView = TrackerDetailsView(flow: TrackerDetailsFlow.edit, trackerInfo: trackerDetails)
        trackersView?.startEditTracker(trackerDetailsView: trackerDetailsView)
    }
    
    func processTrackerClick(trackerId: UUID) {
        trackersAnalyticsRepository.sendTrackerTapEvent()
        
        guard currentSelectedDate <= currentDate else { return }
        let completeTracker = TrackerRecord(id: trackerId, date: currentSelectedDate)
        let isNeedMarkUncomplete =
            trackersRepository.completedTrackers
                .contains(where: { record in
                    record.id == trackerId && currentSelectedDate == record.date
                }
            )
        
        if isNeedMarkUncomplete {
            trackersRepository.deleteTrackerRecord(trackerRecord: completeTracker)
        } else {
            trackersRepository.addTrackerRecord(trackerRecord: completeTracker)
        }
    }
    
    func onBindTrackerCell(cell: TrackerViewCell, tracker: Tracker) {
        let isCurrentTrackerDoneInCurrentDate = trackersRepository.completedTrackers
            .filter { $0.id == tracker.id && $0.date == currentSelectedDate }.count > 0
        let countOfCompleted = trackersRepository.completedTrackers.filter { $0.id == tracker.id }.count
        let trackerViewModel = TrackerView(
            id: tracker.id,
            name: tracker.name,
            color: tracker.color,
            emoji: tracker.emoji,
            isPinned: tracker.isPinned,
            daysCompleted: countOfCompleted.daysString(),
            isDoneInCurrentDate: isCurrentTrackerDoneInCurrentDate
        )
        trackersView?.bindTrackerViewCell(cell: cell, trackerView: trackerViewModel)
    }
    
    private func sortTrackersByPinStatus(currentTrackers: [TrackerCategory]) -> [TrackerCategory] {
        var pinnedTrackers: [Tracker] = []
        var unpinnedCategories: [TrackerCategory] = []
        
        for category in currentTrackers {
            let (pinnedTrackerInCategory, unpinnedTrackers) = category.trackers.partitioned(by: { $0.isPinned })
            if !pinnedTrackerInCategory.isEmpty {
                pinnedTrackers.append(contentsOf: pinnedTrackerInCategory)
            }
            if !unpinnedTrackers.isEmpty {
                unpinnedCategories.append(TrackerCategory(name: category.name, trackers: unpinnedTrackers))
            }
        }
        if pinnedTrackers.isEmpty {
            return unpinnedCategories
        }
        let pinnedCategory = TrackerCategory(name: "Закрепленные", trackers: pinnedTrackers)
        let result = [pinnedCategory] + unpinnedCategories
        return result
    }
    
    func removeTracker(trackerId: UUID) {
        trackersAnalyticsRepository.sendDeleteTrackerEvent()
        guard let tracker = trackersRepository.getTrackerByIdOrNil(trackerId: trackerId) else { return }
        trackersRepository.deleteTracker(tracker: tracker)
    }
}
