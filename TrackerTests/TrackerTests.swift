//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Andrey Zhelev on 24.07.2024.
//
import SnapshotTesting
import XCTest
@testable import Tracker


final class TrackerTests: XCTestCase {
    
    func testTrackersViewControllerLightTheme() throws {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let date = formatter.date(from: "2024/01/01 22:31")
        
        let vc = TrackersViewController(storeService: StoreServiceSpy(), selectedDate: date)
        
        /// перезапись скриншота
//        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .light)), record: true)
        
        assertSnapshots(of: vc, as: [.image(traits: .init(userInterfaceStyle: .light))])
    }
    
    func testTrackersViewControllerDarkTheme() throws {
                
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let date = formatter.date(from: "2024/01/01 22:31")
        
        let vc = TrackersViewController(storeService: StoreServiceSpy(), selectedDate: date)
        
        /// перезапись скриншота
//        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .dark)), record: true)
        
        assertSnapshots(of: vc, as: [.image(traits: .init(userInterfaceStyle: .dark))])
    }
}
