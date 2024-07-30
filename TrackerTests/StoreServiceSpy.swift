//
//  StoreServiceSpy.swift
//  TrackerTests
//
//  Created by Andrey Zhelev on 03.08.2024.
//
import Foundation
@testable import Tracker

final class StoreServiceSpy: StoreServiceProtocol {
    
    var trackersVCdelegate: TrackersVCDelegate?
    var filteredTrackersCount: Int
    var numberOfSections: Int
    var completedTrackers: [TrackerRecord] = []
    var filteredTrackers: [TrackerCategory]
    func getFiltredCategories(selectedDate: Date, selectedWeekDay: Int, searchBarText: String?, selectedFilter: Filters) { }
    func getTrackersCount() -> Int {
        filteredTrackersCount
    }
    func numberOfRowsInSection(_ section: Int) -> Int {
        filteredTrackers[section].trackers.count
    }
    func object(at indexPath: IndexPath) -> Tracker {
        filteredTrackers[indexPath.section].trackers[indexPath.item]
    }
    func isPinned(trackerID: UUID) -> Bool {
        false
    }
    func getSectionName(for section: Int) -> String {
        filteredTrackers[section].category
    }
    func addPinnedTrackerToStore(uuid: UUID) { }
    func deletePinnedTrackerFromStore(uuid: UUID) { }
    func fetchPinnedTrackers() {}
    func getTrackerCategory(for trackerID: UUID) -> String { "" }
    func deleteFromStore(tracker id: UUID) { }
    func addTrackerRecordToStore(record: TrackerRecord) { }
    func deleteRecordFromStore(record: TrackerRecord) { }
    func getFetchedTrackersCount() -> Int {
        filteredTrackersCount
    }
    func addTrackerToStore(tracker: Tracker, eventDate: Date?, to category: String) { }
    func updateTracker(tracker: Tracker, eventDate: Date?, newCategory: String) { }
    
    init() {
        let mockData = Mocks()
        self.filteredTrackersCount = mockData.filteredTrackersCount
        self.numberOfSections = mockData.numberOfSections
        self.filteredTrackers = mockData.filteredTrackers
    }
}
