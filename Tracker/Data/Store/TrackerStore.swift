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
    
    private lazy var fetchRequest: NSFetchRequest<TrackerCoreData> = {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCoreData.id, ascending: true)]
        return fetchRequest
    }()
    
    private lazy var resultsController: NSFetchedResultsController<TrackerCoreData> = {
        let resultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        resultsController.delegate = self
        return resultsController
    }()
    
    override init(storeDelegate: StoreDelegate) {
        super.init(storeDelegate: storeDelegate)
        try? resultsController.performFetch()
    }
    
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
    
    func updateTracker(trackerId: UUID, update: (TrackerCoreData) -> Void) {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", trackerId as CVarArg)
        request.fetchLimit = 1
        guard let tracker = try? context.fetch(request).first else { return }
        update(tracker)
        save()
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        storeDelegate?.didChangeContent()
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
        return Tracker(
            id: id,
            name: name,
            color: color,
            emoji: emoji,
            isPinned: isPinned,
            day: day
        )
    }
}
