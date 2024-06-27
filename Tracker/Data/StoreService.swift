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
    static let storeService = StoreService()
    let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    // MARK: - Private Properties
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private let categoryStore = CategoryStore()
    private let trackerStore = TrackerStore()
    private let trackerRecordStore = TrackerRecordStore()
    
    // MARK: - Initializers
    private init() {}
    
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
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
}
