//
//  StoreService.swift
//  Tracker
//
//  Created by Andrey Zhelev on 27.06.2024.
//
import CoreData
import UIKit

protocol StoreServiceDelegate: AnyObject {
    func updateTrackersCollectionView()
    func updateStub()
}

final class StoreService: NSObject {
    
    // MARK: - Public Properties
    var context: NSManagedObjectContext = AppDelegate.context
    weak var delegate: StoreServiceDelegate?
    
    // MARK: - Private Properties
    private (set) var categoryList: Set<String> = []
    private (set) var completedTrackers: [TrackerRecord] = []
    
    private lazy var trackerStore: TrackerStore = TrackerStore(delegate: self)
    private lazy var categoryStore: CategoryStore = CategoryStore(delegate: self)
    private lazy var trackerRecordStore: TrackerRecordStore = TrackerRecordStore(delegate: self)
    
    private lazy var trackerFetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(TrackerCoreData.category.category), ascending: true)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: #keyPath(TrackerCoreData.category.category),
            cacheName: nil
        )
        controller.delegate = self
        return  controller
    }()
    
    private lazy var recordsFetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData> = {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(TrackerRecordCoreData.uuid), ascending: true)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        return  controller
    }()
    
    // MARK: - Initializers
    init(delegate: StoreServiceDelegate?) {
        super.init()
        self.delegate = delegate
        getStoredRecords()
        fetchCategoryList()
        setRecordsFetchedResultsController()
    }
    
    // MARK: - Public Methods
    func getFiltredCategories(selectedDate: Date, selectedWeekDay: Int, searchBarText: String?) {
        
        let datePredicate = NSPredicate(format: "(%K CONTAINS %@) OR (%K == %@)",
                                        #keyPath(TrackerCoreData.schedule),
                                        String(selectedWeekDay) as CVarArg,
                                        #keyPath(TrackerCoreData.eventDate),
                                        selectedDate as CVarArg)
        
        let searchText = searchBarText?.lowercased() ?? ""
        
        let searchPredicate = searchText == "" ? NSPredicate(format: "TRUEPREDICATE") :
        NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(TrackerCoreData.name), searchText)
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, searchPredicate])
        
        trackerFetchedResultsController.fetchRequest.predicate = predicate
        
        do {
            try trackerFetchedResultsController.performFetch()
        } catch {
            print("@@@ func getFiltredCategories: Ошибка выполнения запроса.")
        }
    }
    
    /// запрашиваем все сохраненные записи о выполненных трекерах
    func getStoredRecords() {
        self.completedTrackers = trackerRecordStore.fetchRecords()
    }
    
    func getTrackersCount() -> Int {
        trackerStore.allTrackersCount()
    }
    
    /// добавляем новый трекер в базу
    func addTrackerToStore(tracker: Tracker, eventDate: Date?, to category: String) {
        categoryStore.storeCategoryWithTracker(
            category: category,
            tracker: trackerStore.addToStore(
                tracker: tracker,
                eventDate: eventDate
            )
        )
        fetchCategoryList()
        delegate?.updateStub()
    }
    
    /// добавляем в базу категории без трекеров
    func addCategoriesToStore(newlist: Set<String>) {
        let newCategories = newlist.subtracting(self.categoryList)
        
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
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            appDelegate.saveContext()
        }
    }
    
    // MARK: - Private Methods
    private func setRecordsFetchedResultsController() {
        do {
            try recordsFetchedResultsController.performFetch()
        } catch {
            print("@@@ private lazy var recordsFetchedResultsController: Ошибка выполнения запроса.")
        }
    }
    
    private func fetchCategoryList() {
        self.categoryList = categoryStore.fetchCategoryList()
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension StoreService: NSFetchedResultsControllerDelegate {
    
    var filteredTrackersCount: Int {
        trackerFetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    var numberOfSections: Int {
        trackerFetchedResultsController.sections?.count ?? 0
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        trackerFetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func object(at indexPath: IndexPath) -> Tracker {
        let trackerCoreData = trackerFetchedResultsController.object(at: indexPath)
        return Tracker(id: trackerCoreData.id ?? UUID(),
                       name: trackerCoreData.name ?? "",
                       color: Int(trackerCoreData.color),
                       emoji: Int(trackerCoreData.emoji),
                       schedule: trackerCoreData.schedule.asSetOfInt
        )
    }
    
    func getSectionName(for section: Int) -> String {
        trackerFetchedResultsController.sections?[section].name ?? ""
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        switch controller {
            
        case trackerFetchedResultsController:
            print("@@@ trackerFetchedResultsController: Уведомление об изменении в контенте.")
            delegate?.updateTrackersCollectionView()
            delegate?.updateStub()
            
        case recordsFetchedResultsController:
            print("@@@ recordsFetchedResultsController: Уведомление об изменении в контенте.")
            getStoredRecords()
            
        default:
            break
        }
    }
}
