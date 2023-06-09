//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 01.05.2023.
//
import CoreData

final class TrackerRecordStore: Store {
    var records: [TrackerRecord] {
        guard let trackerRecordsCoreData = resultsController.fetchedObjects else { return [] }
            
        let trackerRecords = trackerRecordsCoreData.map { trackerRecordCoreData in
            trackerRecordCoreData.toTrackerRecord()
        }.compactMap { $0 }
        return trackerRecords
    }

    private lazy var fetchRequest: NSFetchRequest<TrackerRecordCoreData> = {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCoreData.id, ascending: true)]
        return fetchRequest
    }()
    
    private lazy var resultsController: NSFetchedResultsController<TrackerRecordCoreData> = {
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
    
    func addTrackerRecord(trackerRecord: TrackerRecord) {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.id = trackerRecord.id
        trackerRecordCoreData.date = trackerRecord.date
        save()
    }
    
    func deleteTrackerRecord(trackerRecord: TrackerRecord) {
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "id == %@ AND date >= %@ AND date < %@",
            argumentArray: [trackerRecord.id as CVarArg, trackerRecord.date.startOfDay as CVarArg, trackerRecord.date.endOfDay as CVarArg]
        )
        guard let records = try? context.fetch(request) else { return }
        for record in records {
            context.delete(record)
        }
        save()
    }
}


extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        storeDelegate?.didChangeContent()
    }
}

extension TrackerRecordCoreData {
    
    func toTrackerRecord() -> TrackerRecord? {
        guard let date = date, let id = id else { return nil }
        
        return TrackerRecord(id: id, date: date)
    }
}
