//
//  TrackerStore.swift
//  Tracker
//
//  Created by Andrey Zhelev on 26.06.2024.
//

import UIKit
import CoreData

final class TrackerStore {
    
    private let context: NSManagedObjectContext
    private let storeService = StoreService.storeService
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    convenience init() {
        let context = StoreService.storeService.persistentContainer.viewContext
        self.init(context: context)
    }
    
    func addToStore(_ tracker: Tracker) -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)

        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.color = Int16(tracker.color ?? 0)
        trackerCoreData.emoji = Int16(tracker.emoji ?? 0)
        if let schedule = tracker.schedule {
            trackerCoreData.daysOfWeek = NSSet(set: schedule)
        }
        return trackerCoreData
    }
}
