//
//  MockData.swift
//  Tracker
//
//  Created by Andrey Zhelev on 19.05.2024.
//
import Foundation

final class MockData {
    
    // MARK: - Public Properties
    static let storage = MockData()
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    
    private init() {
        addMockData()
    }
    
    func addMockData() {
        let event1 = Tracker(id: UUID(),
                             name: "Семинар по 14 спринту",
                             color: 7,
                             emoji: 10,
                             schedule: nil
        )
        
        let event2 = Tracker(id: UUID(),
                             name: "Ревью задачи по 14 спринту!!!",
                             color: 1,
                             emoji: 16,
                             schedule: nil
        )
        
        
        categories = [TrackerCategory (category: "Быт",
                                       trackers: [
                                        Tracker(id: UUID(),
                                                name: "Уборка",
                                                color: 10,
                                                emoji: 6,
                                                schedule: [7] //сб
                                               ),
                                        Tracker(id: UUID(),
                                                name: "Поход в супермаркет",
                                                color: 13,
                                                emoji: 13,
                                                schedule: [6] //пт
                                               ),
                                        Tracker(id: UUID(),
                                                name: "Готовлю еду",
                                                color: 9,
                                                emoji: 12,
                                                schedule: [1,3,5] //вт, чт, вс
                                               )
                                       ]
                                      ),
                      TrackerCategory (category: "Образование",
                                       trackers: [
                                        Tracker(id: UUID(),
                                                name: "Учеба на Яндекс Практикуме",
                                                color: 2,
                                                emoji: 10,
                                                schedule: [1,2,3,4,5,6,7]
                                               ),
                                        event1,
                                        event2
                                       ]
                                      ),
                      TrackerCategory (category: "Активность",
                                       trackers: [
                                        Tracker(id: UUID(),
                                                name: "Бассейн",
                                                color: 8,
                                                emoji: 15,
                                                schedule: [2,5] //пн, чт
                                               ),
                                        Tracker(id: UUID(),
                                                name: "Фридайвинг",
                                                color: 9,
                                                emoji: 17,
                                                schedule: [1] //вс
                                               )
                                       ]
                                      )
        ]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        guard let date = formatter.date(from: "27.06.24") else {
            return
        }
        
        completedTrackers = [TrackerRecord(id: event1.id, date: date.short),
                             TrackerRecord(id: event2.id, date: Date().short)
        ]
    }
}
