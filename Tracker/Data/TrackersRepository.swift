//
//  TrackersRepository.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 15.04.2023.
//
import UIKit

final class TrackersRepository {
    static let shared = TrackersRepository()
    static let addTrackerNotification = Notification.Name(rawValue: "AddTrackerNotification")
    
    private var categories: [TrackerCategory] = []
    
    private init() { }
    
    func addNewTracker(tracker: Tracker, categoryName: String) {
        var currentCategories = categories
        let categoryIndex = currentCategories.firstIndex { category in
            category.name == categoryName
        }
        let isCategoryExists = categoryIndex != nil
        if isCategoryExists {
            var currentTrackers = currentCategories[categoryIndex ?? 0].trackers
            currentTrackers.append(tracker)
            currentCategories[categoryIndex ?? 0] = TrackerCategory(name: categoryName, trackers: currentTrackers)
            categories = currentCategories
            return
        }
        let newTrackerCategory = TrackerCategory(name: categoryName, trackers: [tracker])
        currentCategories.append(newTrackerCategory)
        categories = currentCategories
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
}
