//
//  StoreService.swift
//  Tracker
//
//  Created by Andrey Zhelev on 27.06.2024.
//
import CoreData
import UIKit

protocol StoreServiceDelegate: AnyObject {
    var selectedDate: Date { get }
    var selectedFilter: Filters  { get }
    func updateTrackersCollectionView()
    func updateStub()
    func updateFilterButtonState()
}

final class StoreService: NSObject {
    
    // MARK: - Public Properties
    var context: NSManagedObjectContext = AppDelegate.context
    weak var delegate: StoreServiceDelegate?
    
    // MARK: - Private Properties
    private (set) var pinnedTrackers: [UUID] = []
    private (set) var filteredTrackers: [TrackerCategory] = []
    private (set) var categoryList: Set<String> = []
    private (set) var completedTrackers: [TrackerRecord] = []
    private (set) var filteredTrackersCount = 0
    
    
    private lazy var trackerStore: TrackerStore = TrackerStore(delegate: self)
    private lazy var categoryStore: CategoryStore = CategoryStore(delegate: self)
    private lazy var trackerRecordStore: TrackerRecordStore = TrackerRecordStore(delegate: self)
    private lazy var pinnedTrackersStore: PinnedTrackersStore = PinnedTrackersStore(delegate: self)
    
    private lazy var trackerFetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(TrackerCoreData.category.categoryName), ascending: true)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: #keyPath(TrackerCoreData.category.categoryName),
            cacheName: nil
        )
        controller.delegate = self
        
        setRecordsFetchedResultsController()
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
        fetchPinnedTrackers()
        fetchCategoryList()
    }
    
    // MARK: - Public Methods
    func getFiltredCategories(selectedDate: Date, selectedWeekDay: Int, searchBarText: String?, selectedFilter: Filters) {
        
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
        filterTrackers(with: selectedFilter, selectedDate: selectedDate)
    }
    
    func saveContext() {
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            appDelegate.saveContext()
        }
    }
    
    func isPinned(trackerID: UUID) -> Bool {
        return self.pinnedTrackers.contains(trackerID)
    }
    
    // MARK: - Private Methods
    private func setRecordsFetchedResultsController() {
        do {
            try recordsFetchedResultsController.performFetch()
        } catch {
            print("@@@ private lazy var recordsFetchedResultsController: Ошибка выполнения запроса.")
        }
    }
    
    private func filterTrackers(with filter: Filters, selectedDate: Date) {
        filteredTrackersCount = 0
        var pinnedTrackers: [Tracker] = []
        var categoryNames: Set<String> = []
        var newCategories: [(String, [Tracker])] = []
        
        guard let fetchedTrackers = trackerFetchedResultsController.fetchedObjects else {
            return
        }
        
        let filteredTrackers = fetchedTrackers.filter {tracker in
            if completedTrackers.contains(
                where: {record in
                    record.id == tracker.uuid && record.date == selectedDate
                }
            )
                ? filter != .uncompleted
                : filter != .completed
            {
                filteredTrackersCount += 1
                if isPinned(trackerID: tracker.uuid ?? UUID()) {
                    pinnedTrackers.append(Tracker(id: tracker.uuid ?? UUID(),
                                                  name: tracker.name ?? "",
                                                  color: Int(tracker.color),
                                                  emoji: Int(tracker.emoji),
                                                  schedule: tracker.schedule.asSetOfInt
                                                 )
                    )
                } else {
                    categoryNames.insert(tracker.category?.categoryName ?? "")
                    return true
                }
            }
            return false
        }
        
        if pinnedTrackers.count > 0 {
            newCategories.append((NSLocalizedString("storeService.pinnedCategoryName", comment: ""), pinnedTrackers))
        }
        
        categoryNames.sorted().forEach {item in
            newCategories.append((item, []))
        }
        
        filteredTrackers.forEach {item in
            if let index = newCategories.firstIndex(where: {(categoryName, _) in
                item.category?.categoryName ?? "" == categoryName
            }) {
                newCategories[index].1.append(Tracker(id: item.uuid ?? UUID(),
                                                      name: item.name ?? "",
                                                      color: Int(item.color),
                                                      emoji: Int(item.emoji),
                                                      schedule: item.schedule.asSetOfInt)
                )
            }
        }
        
        self.filteredTrackers = []
        newCategories.forEach {(categoryName, trackers) in
            self.filteredTrackers.append(
                TrackerCategory(category: categoryName,
                                trackers: trackers
                               )
            )
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension StoreService: NSFetchedResultsControllerDelegate {
    
    var numberOfSections: Int {
        filteredTrackers.count
    }
    
    func getFetchedTrackersCount() -> Int {
        trackerFetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        filteredTrackers[section].trackers.count
    }
    
    func object(at indexPath: IndexPath) -> Tracker {
        filteredTrackers[indexPath.section].trackers[indexPath.item]
    }
    
    func getSectionName(for section: Int) -> String {
        filteredTrackers[section].category
    }
    
    func getTrackerCategory(for trackerID: UUID) -> String {
        return trackerFetchedResultsController.fetchedObjects?.filter{tracker in
            tracker.uuid == trackerID
        }.first?.category?.categoryName ?? ""
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        switch controller {
            
        case trackerFetchedResultsController:
            filterTrackers(with: delegate?.selectedFilter ?? .all, selectedDate: delegate?.selectedDate ?? Date().short)
            delegate?.updateTrackersCollectionView()
            delegate?.updateStub()
            delegate?.updateFilterButtonState()
            
        case recordsFetchedResultsController:
            getStoredRecords()
            if delegate?.selectedFilter == .completed
                || delegate?.selectedFilter == .uncompleted {
                filterTrackers(with: delegate?.selectedFilter ?? .all, selectedDate: delegate?.selectedDate ?? Date().short)
                delegate?.updateTrackersCollectionView()
                delegate?.updateStub()
            }
            
        default:
            break
        }
    }
}

// MARK: - TrackerStoreDelegate
extension StoreService: TrackerStoreDelegate {
    
    func deleteFromStore(tracker id: UUID) {
        trackerStore.delete(tracker: id)
    }
    
    func getTrackersCount() -> Int {
        trackerStore.allTrackersCount()
    }
}

// MARK: - CategoryStoreDelegate
extension StoreService: CategoryStoreDelegate {
    
    func fetchCategoryList() {
        self.categoryList = categoryStore.fetchCategoryList()
    }
    
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
    
    func addCategoriesToStore(newlist: Set<String>) {
        let newCategories = newlist.subtracting(self.categoryList)
        
        for item in newCategories {
            categoryStore.storeCategory(category: item)
        }
    }
    
    func updateTracker(tracker: Tracker, eventDate: Date?, newCategory: String) {
        deleteFromStore(tracker: tracker.id)
        addTrackerToStore(tracker: tracker, eventDate: eventDate, to: newCategory)
    }
}

// MARK: - TrackerRecordStoreDelegate
extension StoreService: TrackerRecordStoreDelegate {
    
    func getStoredRecords() {
        self.completedTrackers = trackerRecordStore.fetchRecords()
    }
    
    func addTrackerRecordToStore(record: TrackerRecord) {
        trackerRecordStore.storeRecord(record: record)
    }
    
    func deleteRecordFromStore(record: TrackerRecord) {
        trackerRecordStore.deleteRecord(record: record)
    }
}

// MARK: - PinnedTrackersStoreDelegate
extension StoreService: PinnedTrackersStoreDelegate {
    
    func fetchPinnedTrackers() {
        pinnedTrackers = pinnedTrackersStore.fetchPinnedTrackers()
    }
    
    func addPinnedTrackerToStore(uuid: UUID) {
        pinnedTrackersStore.storeTrackerID(trackerID: uuid)
    }
    
    func deletePinnedTrackerFromStore(uuid: UUID) {
        pinnedTrackersStore.deleteFromStore(trackerID: uuid)
    }
}
