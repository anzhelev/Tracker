//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Andrey Zhelev on 27.06.2024.
//

import UIKit
import CoreData

final class TrackerRecordStore {
    
    private let context: NSManagedObjectContext
    private let storeService = StoreService.storeService
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    convenience init() {
        let context = StoreService.storeService.persistentContainer.viewContext
        self.init(context: context)
    }
    
    func fetchRecords() -> [TrackerRecord] {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        
        guard let trackersCoreData = try? context.fetch(request) as [TrackerRecordCoreData] else {
            return []
        }
        
        let records = trackersCoreData.map {item in
            let record = item as AnyObject
            return TrackerRecord(id: record.uuid ?? UUID(),
                                 date: record.date
            )
        }
        return records
    }
    
    func fetchRecordBy(id: UUID, date: Date) -> TrackerRecordCoreData? {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.predicate = NSPredicate(format: "%K == %@ AND %K == %@",
                                        #keyPath(TrackerRecordCoreData.uuid), id as CVarArg,
                                        #keyPath(TrackerRecordCoreData.date), date as CVarArg)
        guard let result = try? context.fetch(request) as [TrackerRecordCoreData],
              let record = result.first else{
            return nil
        }
        return record
    }
    
    func storeRecord(record: TrackerRecord) {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.uuid = record.id
        trackerRecordCoreData.date = record.date
        storeService.saveContext()
    }
    
    func deleteRecord(record: TrackerRecord) {
        if let trackerRecordCoreData = fetchRecordBy(id: record.id, date: record.date) {
            context.delete(trackerRecordCoreData)
            storeService.saveContext()
        }
    }
}
