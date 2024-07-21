//
//  TrackerStore.swift
//  Tracker
//
//  Created by Andrey Zhelev on 26.06.2024.
//
import CoreData
import UIKit

protocol TrackerStoreDelegate: AnyObject {
    
    var context: NSManagedObjectContext {get set}
    func getTrackersCount() -> Int
    func deleteFromStore(tracker id: UUID)
    func saveContext()
}

final class TrackerStore {
    
    private weak var delegate: TrackerStoreDelegate?
    private let context: NSManagedObjectContext
    
    init(delegate: TrackerStoreDelegate) {
        self.delegate = delegate
        self.context = delegate.context
    }
    
    func delete(tracker id: UUID) {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.predicate = NSPredicate(format: "%K == %@",
                                        #keyPath(TrackerCoreData.uuid), id as CVarArg)
        if let result = try? context.fetch(request) as [TrackerCoreData],
           let fetchedTracker = result.first {
            context.delete(fetchedTracker)
        }
        
        delegate?.saveContext()
    }
    
    func addToStore(tracker: Tracker, eventDate: Date?) -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)
        
        trackerCoreData.uuid = tracker.id
        trackerCoreData.eventDate = eventDate
        trackerCoreData.name = tracker.name
        trackerCoreData.color = Int16(tracker.color ?? 0)
        trackerCoreData.emoji = Int16(tracker.emoji ?? 0)
        trackerCoreData.schedule = tracker.schedule.asString
        return trackerCoreData
    }
    
    func allTrackersCount() -> Int {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.resultType = .countResultType
        let count = (try? context.count(for: fetchRequest)) ?? 0
        return count
    }
}
