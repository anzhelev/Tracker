//
//  PinnedTrackersStore.swift
//  Tracker
//
//  Created by Andrey Zhelev on 17.07.2024.
//
import CoreData
import UIKit

protocol PinnedTrackersStoreDelegate: AnyObject {
    
    var context: NSManagedObjectContext { get set }
    func fetchPinnedTrackers()
    func addPinnedTrackerToStore(uuid: UUID)
    func deletePinnedTrackerFromStore(uuid: UUID)
    func saveContext()
}

final class PinnedTrackersStore {
    
    private weak var delegate: PinnedTrackersStoreDelegate?
    private let context: NSManagedObjectContext
    
    init(delegate: PinnedTrackersStoreDelegate) {
        self.delegate = delegate
        self.context = delegate.context
    }
    
    func fetchPinnedTrackers() -> [UUID] {
        let request = NSFetchRequest<PinnedTrackersCoreData>(entityName: "PinnedTrackersCoreData")
        
        guard let pinnedTrackersCoreData = try? context.fetch(request) as [PinnedTrackersCoreData] else {
            return []
        }
        
        return pinnedTrackersCoreData.map {
            $0.trackerID ?? UUID()
        }
    }
    
    func storeTrackerID(trackerID: UUID) {
        let pinnedTrackersCoreData = PinnedTrackersCoreData(context: context)
        pinnedTrackersCoreData.trackerID = trackerID
        delegate?.saveContext()
    }
    
    func deleteFromStore(trackerID: UUID) {
        let request = NSFetchRequest<PinnedTrackersCoreData>(entityName: "PinnedTrackersCoreData")
        request.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(PinnedTrackersCoreData.trackerID), trackerID as CVarArg
        )
        
        if let result = try? context.fetch(request) as [PinnedTrackersCoreData],
           let record = result.first {
            context.delete(record)
            delegate?.saveContext()
        }
    }
}
