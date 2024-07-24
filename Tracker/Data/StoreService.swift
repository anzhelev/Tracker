//
//  StoreService.swift
//  Tracker
//
//  Created by Andrey Zhelev on 27.06.2024.
//
import CoreData
import UIKit

struct TrackerStatisticsData {
    let id: UUID
    let schedule: Set<Int>?
    let eventDate: Date?
}

protocol StoreServiceProtocol {
    var filteredTrackersCount: Int {get }
    var numberOfSections: Int {get}
    var completedTrackers: [TrackerRecord] {get }
    var filteredTrackers: [TrackerCategory] {get }
    func getFiltredCategories(selectedDate: Date, selectedWeekDay: Int, searchBarText: String?, selectedFilter: Filters)
    func getTrackersCount() -> Int
    func numberOfRowsInSection(_ section: Int) -> Int
    func object(at indexPath: IndexPath) -> Tracker
    func isPinned(trackerID: UUID) -> Bool
    func getSectionName(for section: Int) -> String
    func addPinnedTrackerToStore(uuid: UUID)
    func deletePinnedTrackerFromStore(uuid: UUID)
    func fetchPinnedTrackers()
    func getTrackerCategory(for trackerID: UUID) -> String
    func deleteFromStore(tracker id: UUID)
    func addTrackerRecordToStore(record: TrackerRecord)
    func deleteRecordFromStore(record: TrackerRecord)
    func getFetchedTrackersCount() -> Int
    func addTrackerToStore(tracker: Tracker, eventDate: Date?, to category: String)
    func updateTracker(tracker: Tracker, eventDate: Date?, newCategory: String)
}

protocol TrackersVCDelegate: AnyObject {
    var selectedDate: Date { get }
    var selectedFilter: Filters  { get }
    func updateTrackersCollectionView()
    func updateStub()
    func updateFilterButtonState()
}

final class StoreService: NSObject, StoreServiceProtocol {

    // MARK: - Public Properties
    weak var trackersVCdelegate: TrackersVCDelegate?
    var numberOfSections: Int {
        filteredTrackers.count
    }
    var context: NSManagedObjectContext = AppDelegate.context
    
    // MARK: - Private Properties
    private (set) var pinnedTrackers: [UUID] = []
    private (set) var filteredTrackers: [TrackerCategory] = []
    private (set) var categoryList: Set<String> = []
    private (set) var completedTrackers: [TrackerRecord] = [] {
        didSet {
            updateStatistics()
        }
    }
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
    init(trackersVCdelegate: TrackersVCDelegate? = nil) {
        super.init()
        self.trackersVCdelegate = trackersVCdelegate
//        resetAllCoreData()
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
    
    func updateStatistics() {
        let allTrackers = getTrackersForStatistics()
        var setOfDates: Set<Date> = []
        var totalDaysWithTrackers = 0
        var bestPeriod = 0
        var currentPeriod = 0
        var perfectDays = 0
        
        for record in completedTrackers {
            setOfDates.insert(record.date)
        }
        
        var date = setOfDates.sorted().first ?? Date().short
        let totalDaysCount = (Calendar.current.dateComponents([.day], from: date, to: Date().short).day ?? 0) + 1
        
        for _ in 1...totalDaysCount {
            let weekDay = Calendar.current.component(.weekday, from: date)
            
            let totalTrackersInDay = allTrackers.filter {tracker in
                if let schedule = tracker.schedule {
                    return schedule.contains(weekDay)
                }
                if let eventDate = tracker.eventDate {
                    return eventDate == date
                }
                return false
            }.count
            
            let completedTrackersInDay = completedTrackers.filter {record in
                record.date == date
            }.count
            
            if totalTrackersInDay > 0 {
                totalDaysWithTrackers += 1
                if totalTrackersInDay == completedTrackersInDay {
                    perfectDays += 1
                    currentPeriod += 1
                    bestPeriod = max(bestPeriod, currentPeriod)
                } else {
                    currentPeriod = 0
                }
            }
            date = Calendar.current.date(byAdding: .day, value: 1, to: date) ?? date
        }
        
        let average = totalDaysWithTrackers > 0 ? completedTrackers.count / totalDaysWithTrackers : 0
        
        UserDefaults.standard.set(bestPeriod, forKey: "statisticsBestPeriod")
        UserDefaults.standard.set(perfectDays, forKey: "statisticsPerfectDays")
        UserDefaults.standard.set(self.completedTrackers.count, forKey: "statisticsCompletedTrackers")
        UserDefaults.standard.set(average, forKey: "statisticsAverageCount")
    }
    
    
    func resetAllCoreData() {

        let entityNames = AppDelegate.persistentContainer.managedObjectModel.entities.map({ $0.name!})
         entityNames.forEach { [weak self] entityName in
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

            do {
                try self?.context.execute(deleteRequest)
                try self?.context.save()
            } catch {
            }
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
            filterTrackers(with: trackersVCdelegate?.selectedFilter ?? .all, selectedDate: trackersVCdelegate?.selectedDate ?? Date().short)
            trackersVCdelegate?.updateTrackersCollectionView()
            trackersVCdelegate?.updateStub()
            trackersVCdelegate?.updateFilterButtonState()
            
        case recordsFetchedResultsController:
            getStoredRecords()
            if trackersVCdelegate?.selectedFilter == .completed
                || trackersVCdelegate?.selectedFilter == .uncompleted {
                filterTrackers(with: trackersVCdelegate?.selectedFilter ?? .all, selectedDate: trackersVCdelegate?.selectedDate ?? Date().short)
                trackersVCdelegate?.updateTrackersCollectionView()
                trackersVCdelegate?.updateStub()
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
        updateStatistics()
    }
    
    func getTrackersCount() -> Int {
        trackerStore.allTrackersCount()
    }
    
    func getTrackersCountForCategory(categoryName: String) -> Int {
        trackerStore.fetchTrackersCountForCategory(categoryName: categoryName)
    }
    
    func getTrackersForStatistics() -> [TrackerStatisticsData] {
        return trackerStore.fetchAllTrackers().map {tracker in
            TrackerStatisticsData(id: tracker.uuid ?? UUID(),
                                  schedule: tracker.schedule.asSetOfInt,
                                  eventDate: tracker.eventDate)
        }
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
        trackersVCdelegate?.updateStub()
        updateStatistics()
    }
    
    func addCategoriesToStore(newlist: Set<String>) {
        let newCategories = newlist.subtracting(self.categoryList)
        
        for item in newCategories {
            categoryStore.storeCategory(category: item)
        }
    }
    
    func updateCategoryNameInStore(oldName: String, newName: String) {
        categoryStore.editCategoryName(oldName: oldName, newName: newName)
    }
    
    func deleteCategoryFromStore(categoryName: String) {
        categoryStore.deleteCategory(categoryName: categoryName)
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
