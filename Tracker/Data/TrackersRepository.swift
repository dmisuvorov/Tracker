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
