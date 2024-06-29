//
//  StoreService.swift
//  Tracker
//
//  Created by Andrey Zhelev on 27.06.2024.
//

import UIKit
import CoreData

final class StoreService {
    // MARK: - Public Properties
    let appDelegate: AppDelegate
    let context: NSManagedObjectContext

    
    // MARK: - Private Properties
    private (set) var categories: [TrackerCategory] = []
    private (set) var completedTrackers: [TrackerRecord] = []
    private lazy var trackerStore: TrackerStore = TrackerStore(delegate: self)
    private lazy var categoryStore: CategoryStore = CategoryStore(delegate: self)
    private lazy var trackerRecordStore: TrackerRecordStore = TrackerRecordStore(delegate: self)
    
    // MARK: - Initializers
    init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - Public Methods
    /// запрашиваем все сохраненные категории
    func getStoredCategories() -> [TrackerCategory] {
        self.categories = categoryStore.fetchCategories()
        return categories
    }
    /// запрашиваем все сохраненные записи о выполненных трекерах
    func getStoredRecords() -> [TrackerRecord]? {
        self.completedTrackers = trackerRecordStore.fetchRecords()
        return completedTrackers
    }
    
    /// добавляем новый трекер в базу
    func addTrackerToStore(tracker: Tracker, to category: String) {
        categoryStore.storeCategoryWithTracker(category: category, tracker: trackerStore.addToStore(tracker))
    }
    
    /// добавляем в базу категории без трекеров
    func addCategoriesToStore(newlist: Set<String>) {
        var existingCategories: Set<String> = []
        
        for item in categories {
            existingCategories.insert(item.category)
        }
        let newCategories = newlist.subtracting(existingCategories)
        
        for item in newCategories {
            categoryStore.storeCategory(category: item)
        }
    }
    
    /// добавляем новую запись о выполненном трекере в базу
    func addTrackerRecordToStore(record: TrackerRecord) {
        trackerRecordStore.storeRecord(record: record)
    }
    
    /// удаляем запись из базы
    func deleteRecordFromStore(record: TrackerRecord) {
        trackerRecordStore.deleteRecord(record: record)
    }
    
    func saveContext() {
        appDelegate.saveContext()
    }    
}
