//
//  Mocks.swift
//  TrackerTests
//
//  Created by Andrey Zhelev on 03.08.2024.
//

import Foundation
@testable import Tracker

struct Mocks {
    
    let filteredTrackers: [TrackerCategory] = [
        TrackerCategory(
            category: "Test1",
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
    
    var numberOfSections: Int {
        filteredTrackers.count
    }
    
    var filteredTrackersCount: Int {
        var count = 0
        self.filteredTrackers.forEach{
            count += $0.trackers.count
        }
        return count
    }
}
