//
//  TrackersRepository.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 15.04.2023.
//
import UIKit

final class TrackersRepository {
    static let shared = TrackersRepository()
    static let changeContentNotification = Notification.Name(rawValue: "ChangeContentNotification")
    
    @Observable
    private (set) var categories: [TrackerCategory] = []
    private (set) var completedTrackers: Set<TrackerRecord> = []
    
    private lazy var trackerStore: TrackerStore = {
        let trackerStore = TrackerStore(storeDelegate: self)
        return trackerStore
    }()
    
    private lazy var trackerCategoryStore: TrackerCategoryStore = {
        let trackerCategoryStore = TrackerCategoryStore(storeDelegate: self)
        return trackerCategoryStore
    }()
    
    private lazy var trackerRecordStore: TrackerRecordStore = {
        let trackerRecordStore = TrackerRecordStore(storeDelegate: self)
        return trackerRecordStore
    }()
    
    private init() {
        categories = trackerCategoryStore.categories
        completedTrackers = Set(trackerRecordStore.records)
    }
    
    func addCategory(categoryName: String) {
        trackerCategoryStore.addCategory(name: categoryName)
    }
    
    func addNewTracker(tracker: Tracker, categoryName: String) {
        let category: TrackerCategory? = trackerCategoryStore.getByName(name: categoryName)
        if category == nil {
            addCategory(categoryName: categoryName)
        }
        trackerStore.addTracker(tracker: tracker, category: trackerCategoryStore.getByName(name: categoryName))
    }
    
    func pinTracker(tracker: Tracker) {
        trackerStore.updateTracker(trackerId: tracker.id) { trackerCD in
            trackerCD.isPinned = true
        }
    }
    
    func unpinTracker(tracker: Tracker) {
        trackerStore.updateTracker(trackerId: tracker.id) { trackerCD in
            trackerCD.isPinned = false
        }
    }
    
    func getTrackerByIdOrNil(trackerId: UUID) -> Tracker? {
        let trackerCategories = getTrackersByFilter { tracker in tracker.id == trackerId }
        if trackerCategories.isEmpty {
            return nil
        }
        
        return trackerCategories.first?.trackers.first ?? nil
    }
    
    func getTrackerDetailsInfoByIdOrNil(trackerId: UUID) -> TrackerDetailsInfo? {
        let trackerCategories = getTrackersByFilter { tracker in tracker.id == trackerId }
        guard trackerCategories.isEmpty == false,
            let currentCategory = trackerCategories.first,
            let currentTracker = currentCategory.trackers.first else { return nil }
        
        let currentTrackerType = currentTracker.day == nil ? TrackerType.irregularEvent : TrackerType.habit
        let countCompleted = completedTrackers.filter { $0.id == currentTracker.id }.count
        return TrackerDetailsInfo(
            categoryName: currentCategory.name,
            type: currentTrackerType,
            countCompleted: countCompleted,
            trackerDetails: currentTracker
        )
    }
    
    func getTrackersByFilter(filter: (Tracker) -> Bool) -> [TrackerCategory] {
        var resultCategories: [TrackerCategory] = []
        categories.forEach { category in
            let currentTrackers = category.trackers.filter { tracker in
                filter(tracker)
            }
            if currentTrackers.count > 0 {
                resultCategories.append(TrackerCategory(name: category.name, trackers: currentTrackers))
            }
        }
        return resultCategories
    }
    
    func getTrackerCategoriesByFilter(filter: (TrackerCategory) -> Bool) -> [TrackerCategory] {
        var resultCategories: [TrackerCategory] = []
        categories.forEach { category in
            if filter(category) {
                resultCategories.append(category)
            }
        }
        return resultCategories
    }
    
    func addTrackerRecord(trackerRecord: TrackerRecord) {
        trackerRecordStore.addTrackerRecord(trackerRecord: trackerRecord)
    }
    
    func deleteTrackerRecord(trackerRecord: TrackerRecord) {
        trackerRecordStore.deleteTrackerRecord(trackerRecord: trackerRecord)
    }
}

extension TrackersRepository: StoreDelegate {
    
    func didChangeContent() {
        categories = trackerCategoryStore.categories
        completedTrackers = Set(trackerRecordStore.records)
        
        NotificationCenter.default.post(name: TrackersRepository.changeContentNotification, object: nil)
    }
}
