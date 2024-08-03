//
//  CategoryStore.swift
//  Tracker
//
//  Created by Andrey Zhelev on 27.06.2024.
//
import CoreData
import UIKit

protocol CategoryStoreDelegate: AnyObject {
    var context: NSManagedObjectContext {get set}
    func fetchCategoryList()
    func addTrackerToStore(tracker: Tracker, eventDate: Date?, to category: String)
    func addCategoriesToStore(newlist: Set<String>)
    func saveContext()
}

final class CategoryStore {
    
    private weak var delegate: CategoryStoreDelegate?
    private let context: NSManagedObjectContext
    
    init(delegate: CategoryStoreDelegate) {
        self.delegate = delegate
        self.context = delegate.context
    }
    
    func fetchCategoryList() -> Set <String> {
        
        let request = NSFetchRequest<CategoryCoreData>(entityName: "CategoryCoreData")
        guard let storedCategories = try? context.fetch(request) else {
            print("@@@ func fetchCategories: Сохраненные категории отсутствуют")
            return []
        }
        
        var categories: Set <String> = []
        
        storedCategories.forEach {item in
            if let category = item.categoryName {
                categories.insert(category)
            }
        }
        return categories
    }
    
    func storeCategory(category title: String) {
        let categoryCoreData = CategoryCoreData(context: context)
        
        categoryCoreData.categoryName = title
        categoryCoreData.trackers = []
        delegate?.saveContext()
    }
    
    func storeCategoryWithTracker(category title: String, tracker: TrackerCoreData) {
        
        let request = NSFetchRequest<CategoryCoreData>(entityName: "CategoryCoreData")
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(CategoryCoreData.categoryName), title)
        
        guard let categoryCoreData = try? context.fetch(request) else {
            print("@@@ func storeCategoryWithTracker: Ошибка получения категории для сохранения нового трекера")
            return
        }
        tracker.category = categoryCoreData[0]
        delegate?.saveContext()
    }
    
    func deleteCategory(categoryName: String) {
        let request = NSFetchRequest<CategoryCoreData>(entityName: "CategoryCoreData")
        request.predicate = NSPredicate(format: "%K == %@",
                                        #keyPath(CategoryCoreData.categoryName), categoryName as CVarArg)
        if let result = try? context.fetch(request) as [CategoryCoreData],
           let fetchedCategory = result.first {
            context.delete(fetchedCategory)
        }
        delegate?.saveContext()
    }
    
    func editCategoryName(oldName: String, newName: String) {
        let request = NSFetchRequest<CategoryCoreData>(entityName: "CategoryCoreData")
        request.predicate = NSPredicate(format: "%K == %@",
                                        #keyPath(CategoryCoreData.categoryName), oldName as CVarArg)
        if let result = try? context.fetch(request) as [CategoryCoreData],
           let fetchedCategory = result.first {
            fetchedCategory.categoryName = newName
        }
        delegate?.saveContext()
    }
}
