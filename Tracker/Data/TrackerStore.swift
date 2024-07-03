//
//  TrackerStore.swift
//  Tracker
//
//  Created by Andrey Zhelev on 26.06.2024.
//

import UIKit
import CoreData

final class TrackerStore {
    
    private weak var delegate: StoreService?
    private let context: NSManagedObjectContext
    
    init(delegate: StoreService) {
        self.delegate = delegate
        self.context = delegate.context
    }
    
    func addToStore(tracker: Tracker, eventDate: Date?) -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)

        trackerCoreData.id = tracker.id
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
