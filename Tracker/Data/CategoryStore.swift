//
//  CategoryStore.swift
//  Tracker
//
//  Created by Andrey Zhelev on 27.06.2024.
//

import UIKit
import CoreData

final class CategoryStore {
    
    private let context: NSManagedObjectContext
    private let storeService = StoreService.storeService
    

    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    convenience init() {
        let context = StoreService.storeService.persistentContainer.viewContext
        self.init(context: context)
    }
    
    func fetchCategories() -> [TrackerCategory] {
        
        let request = NSFetchRequest<CategoryCoreData>(entityName: "CategoryCoreData")
        
        guard let storedCategories = try? context.fetch(request) else {
            print("@@@ func fetchCategories: Сохраненные категории отсутствуют")
            return []
        }
        
        let categories: [TrackerCategory] = storedCategories.map {item in
            guard let category = item.category else {
                fatalError("@@@ func fetchCategories: Ошибка получения названия категории")
            }
            
            var trackers: [Tracker] = []
            
            if let storedTrackers = item.trackers {
                storedTrackers.forEach {
                let tracker = $0 as AnyObject
                    trackers.append(Tracker(id: tracker.id ?? UUID(),
                                            name: tracker.name,
                                            color: Int(tracker.color),
                                            emoji: Int(tracker.emoji),
                                            schedule: tracker.daysOfWeek as? Set<Int> 
                                           )
                    )
                }
            }
            return TrackerCategory(category: category,
                                   trackers: trackers)
        }
        
        return categories
    }
    
    func storeCategory(category title: String) {
        let categoryCoreData = CategoryCoreData(context: context)
        
        categoryCoreData.category = title
        categoryCoreData.trackers = []
        storeService.saveContext()
    }
    
    func storeCategoryWithTracker(category title: String, tracker: TrackerCoreData) {
        
        let request = NSFetchRequest<CategoryCoreData>(entityName: "CategoryCoreData")
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(CategoryCoreData.category), title)
        
        guard let categoryCoreData = try? context.fetch(request) else {
            print("@@@ func storeCategoryWithTracker: Ошибка получения категории для сохранения нового трекера")
            return
        }
        
        categoryCoreData[0].addToTrackers(tracker)
        storeService.saveContext()
    }
}
