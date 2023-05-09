//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 01.05.2023.
//
import UIKit
import CoreData

final class TrackerCategoryStore: Store {
    var categories: [TrackerCategory] {
        guard let trackerCategoryCoreData = resultsController.fetchedObjects else { return [] }
            
        let trackerCategories = trackerCategoryCoreData.map { trackerCategoryCoreData in
            trackerCategoryCoreData.toTrackerCategory(decoder: decoder)
        }.compactMap { $0 }
        return trackerCategories
    }
    
    private let decoder = JSONDecoder()
    
    private lazy var fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCategoryCoreData.name, ascending: true)]
        return fetchRequest
    }()
    
    private lazy var resultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
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
    
    func addCategory(name: String) {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.name = name
        trackerCategoryCoreData.trackers = []
        save()
    }
    
    func getByName(name: String) -> TrackerCategoryCoreData? {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }
    
    func getByName(name: String) -> TrackerCategory? {
        return getByName(name: name)?.toTrackerCategory(decoder: decoder)
    }
}


extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        storeDelegate?.didChangeContent()
    }
}

extension TrackerCategoryCoreData {
    
    func toTrackerCategory(decoder: JSONDecoder) -> TrackerCategory? {
        guard let name = name, let trackersCoreData = trackers else { return nil }
        let trackers = trackersCoreData.map { trackerCoreData in
            (trackerCoreData as? TrackerCoreData)?.toTracker(decoder: decoder)
        }.compactMap{ $0 }
        return TrackerCategory(name: name, trackers: trackers)
    }
}
