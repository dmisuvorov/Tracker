//
//  TrackerStore.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 01.05.2023.
//
import UIKit
import CoreData

final class TrackerStore: Store {
    private let encoder = JSONEncoder()
    
    func addTracker(tracker: Tracker, category: TrackerCategoryCoreData?) {
        guard let category else { return }
        
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.color = tracker.color
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.category = category
        if let schedule = tracker.day {
            trackerCoreData.schedule = try? encoder.encode(schedule)
        }
        
        save()
    }
}

extension TrackerCoreData {
    
    func toTracker(decoder: JSONDecoder) -> Tracker? {
        guard let id = id,
              let name = name,
              let color = color,
              let emoji = emoji else { return nil }
        var day: Set<Day>? = nil
        if let schedule = schedule {
            day = try? decoder.decode(Set<Day>.self, from: schedule)
        }
        return Tracker(id: id, name: name, color: color, emoji: emoji, day: day)
    }
}
