//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Andrey Zhelev on 24.07.2024.
//

import XCTest
import SnapshotTesting
@testable import Tracker



final class StoreServiceSpy: StoreServiceProtocol {
    var filteredTrackersCount: Int = 1
    var numberOfSections: Int = 1
    var completedTrackers: [TrackerRecord] = []
    var filteredTrackers: [TrackerCategory] = [
        TrackerCategory(category: "Test1",
                        trackers: [Tracker(id: UUID(),
                                           name: "Tracker1",
                                           color: 1,
                                           emoji: 1,
                                           schedule: [1,2,3,4,5,6,7]
                                          ),
                                   Tracker(id: UUID(),
                                           name: "Tracker2",
                                           color: 2,
                                           emoji: 2,
                                           schedule: [1,2,3,4,5,6,7]
                                          )
                        ])
    ]
    
    func getFiltredCategories(selectedDate: Date, selectedWeekDay: Int, searchBarText: String?, selectedFilter: Filters) { }
    func getTrackersCount() -> Int {
        filteredTrackers[0].trackers.count
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
        2
    }
    func addTrackerToStore(tracker: Tracker, eventDate: Date?, to category: String) {}
    func updateTracker(tracker: Tracker, eventDate: Date?, newCategory: String) {}
    
}


final class TrackerTests: XCTestCase {

    func testTrackersViewController() throws {
        
//        isRecording = true
        
        let vc = TrackersViewController()
        vc.storeService = StoreServiceSpy()
        vc.updateTrackersCollectionView()
        
        assertSnapshots(of: vc, as: [.image(traits: .init(userInterfaceStyle: .light))])
    }
}
